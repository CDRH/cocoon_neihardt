#!/usr/bin/python3
"""Usage: post xml files to solr
Options:
    Invert most options using the upper-case version of the option. For example
    'post.py -uCO --DELETE' will update the the solr index, but won't commit,
    update or delete existing documents. Default options are 'post.py -uco'
-c, --commit    commit the new solr index when finished processing
-d, --delete    by itself, delete all documents in the index. when accompanied
  with --update, will delete all documents and then update
-d, --delete DOCID    Deletes the document with the provided DOCID (this option
  doesn't have an inverse)
-h, --help    give this message
-o, --optimize    optimize the solr index when finished processing
-u, --update    update the solr index with new docs
"""

import os
import sys
from datetime import datetime
import re
import getopt
import subprocess
import urllib.request
import urllib.parse
import urllib.error


class Usage(Exception):
    """
    Exception class to print usage information, in the file docstring
    """

    def __init__(self, msg):
        Exception.__init__(self)
        self.msg = msg


class SolrPost:
    "placeholder docstring"

    solr_url = "http://cdrhsearch.unl.edu:8080/solr/neihardt/update"
    source = "../xml/content/"
    source_regex = r"[A-Za-z].*\.xml"
    destination = "../xml/solr/"
    recursive = True
    xslt_script = "neihardt2solr.xsl"
    xslt_jar = "lib/saxon9he.jar"
    log_dir = os.path.abspath("logs")
    log = "post.log"

    log_file = ""

    __short_options = "cdhouCDHOU"
    __long_options = ["commit", "delete", "help", "optimize", "update",
                      "COMMIT", "DELETE", "OPTIMIZE", "UPDATE"]
    __commit = None
    __delete = None
    __optimize = None
    __update = None

    def init(self, argv=None):
        self.initLog()
        self.processArguments(argv)
        self.collectFiles()
        self.prune()

    def process(self):
        if self.__delete:
            self.delete_all()

        if self.__update:
            self.transformAndPost()

        if self.__commit:
            self.commit()

        if self.__optimize:
            self.optimize()

    def cleanup(self):
        self.close()

    def processArguments(self, argv=None):
        if argv != None:
            try:
                try:
                    opts, args = getopt.getopt(
                        argv[1:], self.__short_options, self.__long_options)
                except getopt.error as msg:
                    raise Usage(msg)
            except Usage as err:
                print >> sys.stderr, err.msg
                print >> sys.stderr, "for help use --help"
                exit(2)

            #process options
            for o, a in opts:
                if o in ("-c", "--commit"):
                    if self.__commit == None:
                        self.__commit = True
                    else:
                        print("Cannot process arguments, commit already set")
                        exit(1)
                elif o in ("-C", "--COMMIT"):
                    if self.__commit == None:
                        self.__commit = False
                    else:
                        print("Cannot process arguments, commit already set")
                        exit(1)
                elif o in ("-d", "--delete"):
                    if self.__delete == None:
                        self.__delete = True
                    else:
                        print("Cannot process arguments, delete already set")
                        exit(1)
                elif o in ("-D", "--DELETE"):
                    if self.__delete == None:
                        self.__delete = False
                    else:
                        print("Cannot process arguments, delete already set")
                        exit(1)
                elif o in ("-h", "--help"):
                    print(__doc__)
                    sys.exit(0)
                elif o in ("-o", "--optimize"):
                    if self.__optimize == None:
                        self.__optimize = True
                    else:
                        print("Cannot process arguments, optimize already set")
                        exit(1)
                elif o in ("-O", "--OPTIMIZE"):
                    if self.__optimize == None:
                        self.__optimize = False
                    else:
                        print("Cannot process arguments, optimize already set")
                        exit(1)
                elif o in ("-u", "--update"):
                    if self.__update == None:
                        self.__update = True
                    else:
                        print("Cannot process arguments, update already set")
                        exit(1)
                elif o in ("-U", "--UPDATE"):
                    if self.__update == None:
                        self.__update = False
                    else:
                        print("Cannot process arguments, update already set")
                        exit(1)

        if self.__commit == None:
            self.__commit = True
        if self.__delete == None:
            self.__delete = False
        if self.__optimize == None:
            self.__optimze = True
        if self.__update == None:
            self.__update = True

        self.source_dir = os.path.abspath(self.source)
        if not os.path.isdir(self.source_dir):
            raise Exception("Error: Path " + self.source + " is not a valid " +
                            "directory")

        self.dest_dir = os.path.abspath(self.destination)
        if not os.path.isdir(self.dest_dir):
            os.mkdir(self.dest_dir)

        self.xslt_jar = os.path.abspath(self.xslt_jar)
        if not os.path.isfile(self.xslt_jar):
            raise Exception("Error: xslt jar invalid (" + self.xslt_jar + ")")

        self.xslt_script = os.path.abspath(self.xslt_script)
        if not os.path.isfile(self.xslt_script):
            raise Exception("Error: xslt script invalid (" + self.xslt_script
                            + ")")

    def initLog(self):
        self.log = os.path.normpath(os.path.join(self.log_dir, self.log))
        if not os.path.isdir(self.log_dir):
            os.mkdir(self.log_dir)
        self.log_file = open(self.log, "w")

        self.log_message("Using '" + self.log + "' as log file")

    def collectFiles(self):
        self.log_message("Collecting files")
        self.log_message("Using regex: '" + self.source_regex + "'")

        self.proc_files = []
        for root, dirs, files in os.walk(self.source_dir):
            if ".svn" in dirs:
                dirs.remove(".svn")

            for dir in dirs:
                if self.dest_dir == os.path.join(os.path.abspath(root), dir):
                    dirs.remove(dir)
                    break

            prog = re.compile(self.source_regex)
            for file in files:
                if prog.match(file):
                    self.proc_files.append(os.path.join(os.path.abspath(root),
                                                        file))

        self.log_message("Finished collecting files")
        self.log_message("Files to be processed: " + str(self.proc_files),
                         print_to_stdout=False)

    def prune(self):
        return

    def transformAndPost(self):
        self.log_message("Transforming files")

        for file in self.proc_files:
            self.log_message("Processing " + file)
            cmd = [
                "java", "-cp", self.xslt_jar,
                "net.sf.saxon.Transform", "-w0", file, self.xslt_script
            ]

            p = subprocess.Popen(cmd, stdout=subprocess.PIPE,
                                 stderr=subprocess.PIPE)
            stdout, stderr = p.communicate()

            if stderr:
                self.log_message("Error: " + str(stderr))
            else:
                self.post(stdout)

    def post(self, document):
        self.log_message("Posting...")

        request = urllib.request.Request(self.solr_url, data=document)
        request.add_header('Content-type', 'text/xml')
        response = urllib.request.urlopen(request)
        output = response.read()

        if response.code == 200:
            self.log_message("Successfully posted file")
        else:
            self.log_message("Failed to post file, output in log")
            self.log_message(output, print_to_stdout=False)

        response.close()

    def commit(self):
        self.log_message("Committing changes...")

        message = b"<commit />"
        request = urllib.request.Request(self.solr_url, data=message)
        request.add_header('Content-type', 'text/xml')
        response = urllib.request.urlopen(request)
        output = response.read()

        if response.code == 200:
            response.close()
            self.log_message("Successfully committed")
        else:
            response.close()
            raise Exception("Error: Unable to commit")

    def delete(self, id):
        self.log_message("Deleting document with id: " + id + "...")

        message = b"<delete><query>id:" + id + "</query></delete>"
        request = urllib.request.Request(self.solr_url, data=message)
        request.add_header('Content-type', 'text/xml')
        response = urllib.request.urlopen(request)
        output = response.read()

        if response.code == 200:
            response.close()
            self.log_message("Successfully deleted")
        else:
            response.close()
            raise Exception("Error: Unable to delete")

    def delete_all(self):
        self.log_message("Deleting all documents...")

        message = b"<delete><query>*:*</query></delete>"
        request = urllib.request.Request(self.solr_url, data=message)
        request.add_header('Content-type', 'text/xml')
        response = urllib.request.urlopen(request)
        output = response.read()

        if response.code == 200:
            response.close()
            self.log_message("Successfully deleted")
        else:
            response.close()
            raise Exception("Error: Unable to delete")

    def optimize(self):
        self.log_message("Committing changes...")

        message = b"<optimize />"
        request = urllib.request.Request(self.solr_url, data=message)
        request.add_header('Content-type', 'text/xml')
        response = urllib.request.urlopen(request)
        output = response.read()

        if response.code == 200:
            response.close()
            self.log_message("Successfully optimized")
        else:
            response.close()
            raise Exception("Error: Unable to optimize")

    def close(self):
        self.log_file.close()

    def log_message(self, message, print_to_stdout=True):
        now = datetime.now()
        format = "%c"
        self.log_file.write("[" + datetime.strftime(now, format) + "]: " +
                            message + "\n")
        if print_to_stdout:
            print(message)

    def __init__(self, argv=None):
            if argv == None:
                argv = sys.argv
        #try:
            self.init(argv)
            self.process()
            self.cleanup()
        #except Exception as e:
        #    self.log_message(str(e))
        #    self.log_message("Exiting...")


if __name__ == "__main__":
    SolrPost()

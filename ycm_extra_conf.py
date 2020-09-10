# Based on https://github.com/martong/ycm_extra_conf.jsondb

import os
import sys
import fnmatch
import re
import ycm_core
import json
import itertools

# These are the compilation flags that will be used in case there's no
# compilation database set (by default, one is not set).
# CHANGE THIS LIST OF FLAGS. YES, THIS IS THE DROID YOU HAVE BEEN LOOKING FOR.
flags = [
'-Wall',
'-Wextra',
'-Werror',
'-Wc++98-compat',
'-Wno-long-long',
'-Wno-variadic-macros',
'-fexceptions',
# THIS IS IMPORTANT! Without a "-std=<something>" flag, clang won't know which
# language to use when compiling headers. So it will guess. Badly. So C++
# headers will be compiled as C headers. You don't want that so ALWAYS specify
# a "-std=<something>".
# For a C project, you would set this to something like 'c99' instead of
# 'c++11'.
'-std=c++1y',
# ...and the same thing goes for the magic -x option which specifies the
# language that the files to be compiled are written in. This is mostly
# relevant for c++ headers.
# For a C project, you would set this to 'c' instead of 'c++'.
'-x', 'c++',
'-isystem', '/System/Library/Frameworks/Python.framework/Headers',
'-I', '.',
'-I', './ClangCompleter',
'-isystem', '/usr/include',
'-isystem', '/usr/local/include'
]


# Set this to the absolute path to the folder (NOT the file!) containing the
# compile_commands.json file to use that instead of 'flags'. See here for
# more details: http://clang.llvm.org/docs/JSONCompilationDatabase.html
#
# You can get CMake to generate this file for you by adding:
#   set( CMAKE_EXPORT_COMPILE_COMMANDS 1 )
# to your CMakeLists.txt file.
#
# Most projects will NOT need to set this to anything; you can just change the
# 'flags' list of compilation flags. Notice that YCM itself uses that approach.

# TODO detect this automatically
compilation_database_folders = [
'build/osx_x64_debug/make/',
'bin/'
'build'
]

database = None
for compilation_database_folder in compilation_database_folders:
  if os.path.exists( compilation_database_folder ):
    database = ycm_core.CompilationDatabase( compilation_database_folder )
    break

SOURCE_EXTENSIONS = [ '.cpp', '.cxx', '.cc', '.c', '.m', '.mm' ]

def DirectoryOfThisScript():
  return os.path.dirname( os.path.abspath( __file__ ) )


def MakeRelativePathsInFlagsAbsolute( flags, working_directory ):
  if not working_directory:
    return list( flags )
  new_flags = []
  make_next_absolute = False
  path_flags = [ '-isystem', '-I', '-iquote', '--sysroot=' ]
  for flag in flags:
    new_flag = flag

    if make_next_absolute:
      make_next_absolute = False
      if not flag.startswith( '/' ):
        new_flag = os.path.join( working_directory, flag )

    for path_flag in path_flags:
      if flag == path_flag:
        make_next_absolute = True
        break

      if flag.startswith( path_flag ):
        path = flag[ len( path_flag ): ]
        new_flag = path_flag + os.path.join( working_directory, path )
        break

    if new_flag:
      new_flags.append( new_flag )
  return new_flags


def IsHeaderFile( filename ):
  extension = os.path.splitext( filename )[ 1 ]
  return extension in [ '.h', '.hxx', '.hpp', '.hh' ]

def pairwise(iterable):
  "s -> (s0,s1), (s1,s2), (s2, s3), ..."
  a, b = itertools.tee(iterable)
  next(b, None)
  return itertools.izip(a, b)


def removeClosingSlash(path):
  if path.endswith('/'):
    path = path[:-1]
  return path

def debugLog(msg):
  print(msg)
  sys.stdout.flush()

def searchForTranslationUnitWhichIncludesPath(compileCommandsPath, path):
  path = removeClosingSlash(path)
  path = os.path.normpath(path)
  m = re.match( r'(.*/include)', path)
  if m:
    path = m.group(1)
    debugLog ("path: " + path)
  else:
    debugLog ("Path regex does not match")
    return None
  jsonData = open(compileCommandsPath)
  data = json.load(jsonData)
  for translationUnit in data:
    switches = translationUnit["command"].split()
    for currentSwitch, nextSwitch in pairwise(switches):
      matchObj = re.match( r'(-I|-isystem)(.*)', currentSwitch)
      includeDir = ""
      if currentSwitch == "-I" or currentSwitch == "-isystem":
        includeDir = nextSwitch
      elif matchObj:
        includeDir = matchObj.group(2)
      includeDir = removeClosingSlash(includeDir)
      includeDir = os.path.normpath(includeDir)
      if includeDir == path:
        debugLog ("Found " + translationUnit["file"])
        # TODO finally
        jsonData.close()
        return str(translationUnit["file"])
  jsonData.close()
  debugLog ("Not Found")
  return None

def findFirstSiblingSrc(dirname):
  fileMatches = []
  for root, dirnames, filenames in os.walk(dirname):
    for filename in filenames:
      if filename.endswith(tuple(SOURCE_EXTENSIONS)):
        return os.path.join(root, filename);
  return None

def getFirstEntryOfACompilationDB(compileCommandsPath):
  jsonData = open(compileCommandsPath)
  data = json.load(jsonData)
  # TODO finally
  jsonData.close()
  return str(data[0]["file"])

def GetCompilationInfoForFile( filename ):
  debugLog ("GetCompilationInfoForFile: filename: " + filename)

  basename = os.path.split( filename ) [ 1 ]
  dirname = os.path.dirname( filename )

  # The compilation_commands.json file generated by CMake does not have entries
  # for header files. So we do our best by asking the db for flags for a
  # corresponding source file, if any. If one exists, the flags for that file
  # should be good enough.
  if IsHeaderFile( filename ):
    basename = os.path.splitext( filename )[ 0 ]
    for extension in SOURCE_EXTENSIONS:
      replacement_file = basename + extension
      if os.path.exists( replacement_file ):
        debugLog ("Matching src file, based on method0: " + replacement_file)
        compilation_info = database.GetCompilationInfoForFile(
          replacement_file )
        if compilation_info.compiler_flags_:
          return compilation_info

    # If still not found a candidate translation unit,
    # then try to browse the json db to find one,
    # which uses the directory of our header as an include path (-I, -isystem).
    compilation_database_file = compilation_database_folder + "/" + "compile_commands.json"
    candidateSrcFile = searchForTranslationUnitWhichIncludesPath(compilation_database_file, dirname)
    if candidateSrcFile != None:
      debugLog ("Matching src file, based on searchForTranslationUnitWhichIncludesPath: " + candidateSrcFile)
    else:
      candidateSrcFile = findFirstSiblingSrc(dirname)
      if candidateSrcFile != None:
        debugLog ("Matching src file, based on findFirstSiblingSrc: " + candidateSrcFile)
      else:
        candidateSrcFile = getFirstEntryOfACompilationDB(compilation_database_file)
        if candidateSrcFile != None:
          debugLog ("Matching src file, based on getFirstEntryOfACompilationDB: " + candidateSrcFile)

    if (candidateSrcFile == None):
      debugLog("Could not find any matches")
      candidateSrcFile = ""
    return database.GetCompilationInfoForFile(candidateSrcFile)

  # Src file
  result = database.GetCompilationInfoForFile( filename )
  candidateSrcFile = filename
  # TODO this is a bit redundant with the header part
  if not result.compiler_flags_:
    candidateSrcFile = findFirstSiblingSrc(dirname)
    if candidateSrcFile != None:
      debugLog ("Matching src file, based on findFirstSiblingSrc: " + candidateSrcFile)
    else:
      candidateSrcFile = getFirstEntryOfACompilationDB(compilation_database_file)
      if candidateSrcFile != None:
        debugLog ("Matching src file, based on getFirstEntryOfACompilationDB: " + candidateSrcFile)

    if (candidateSrcFile == None):
      debugLog("Could not find any matches")
      candidateSrcFile = ""

  return database.GetCompilationInfoForFile(candidateSrcFile)

def FlagsForFile( filename, **kwargs ):
  if database:
    # Bear in mind that compilation_info.compiler_flags_ does NOT return a
    # python list, but a "list-like" StringVec object
    compilation_info = GetCompilationInfoForFile( filename )
    if not compilation_info:
      return None

    final_flags = MakeRelativePathsInFlagsAbsolute(
      compilation_info.compiler_flags_,
      compilation_info.compiler_working_dir_ )

    final_flags.extend(
      [
        '-isystem', '/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/usr/include',
        '-isystem', '/usr/include/c++/4.2.1'
      ]
    )
  else:
    relative_to = DirectoryOfThisScript()
    final_flags = MakeRelativePathsInFlagsAbsolute( flags, relative_to )

  return {
    'flags': final_flags,
    'do_cache': True
  }

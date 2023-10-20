def getBuildPlatform():
	from sys import platform
	match platform:
		case "aix":
			return "unix"
		case "linux":
			return "unix"
		case "windows":
			return "windows"
		case "win32":
			return "windows"
		case "cygwin":
			return "unix"
		case "darwin":
			return "unix"

def getLanguageSwitch():
	import sys
	return sys.argv[1]

def getPlatformSwitch():
	import sys
	return "-D " + sys.argv[2]

buildPlatform = getBuildPlatform()
languageSwitch = getLanguageSwitch()
platformSwitch = getPlatformSwitch()

def buildPath(arr):
	global buildPlatform
	match buildPlatform:
		case "unix":
			return "/".join(arr)
		case "windows":
			return "\\".join(arr)

def mkdir(path):
	import os
	try:
		os.mkdir(buildPath(path))
	except:
		pass

def rm(path):
	import shutil
	try:
		shutil.rmtree(buildPath(path))
	except:
		pass
	import os
	try:
		os.remove(buildPath(path))
	except:
		pass
	try:
		os.unlink(buildPath(path))
	except:
		pass

def move(src, to):
	import os
	rm(to)
	os.rename(buildPath(src), buildPath(to))

def append(src, to, appending):
	with open(buildPath(to), "a" if appending else "w+") as fo:
		with open(buildPath(src), "r") as fi:
			fo.write(fi.read())
def run(program, parameters):
	import os
	print(" ".join([program] + parameters))
	os.system(" ".join([program] + parameters))

def haxe(out, src, package, defines):
	global languageSwitch
	global platformSwitch
	if defines == None:
		defines = [ ]
	for i in range(len(src)):
		src[i] = "-cp " + src[i]
	run("haxe", [languageSwitch, buildPath(["out", out])] + src + [ package, platformSwitch] + defines)

if languageSwitch != "CLEAN":
	out1 = "gsatk"
	if languageSwitch == "--python":
		out2 = ".py"
		appendFile = "Append_To_Beginning.py"
	elif platformSwitch == "-D JS_BROWSER":
		out2 = "-browser.js"
		appendFile = "Append_To_Beginning.txt"
	out = out1 + out2
	print("Building Library")
	mkdir(["out"])
	rm(["out", "build.tmp"])
	rm(["out", "fe-browser.js"])
	haxe(out, ["src"], "com.gsatk", None)
	move(["out", out], ["out", "build.tmp"])
	append([appendFile], ["out", out], False)
	append(["out", "build.tmp"], ["out", out], True)
	rm(["out", "build.tmp"])
else:
	rm(["out"])

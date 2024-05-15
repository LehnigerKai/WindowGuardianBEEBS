import os

if __name__ == "__main__":
	with open("CMakeLists.txt", "w") as out_file:
		out_file.write("set(BENCHMARK $ENV{BENCHMARK})\n")
		first = True
		for subdir in [d for d in os.scandir(".") if d.is_dir()]:
			# get c files
			files = [subdir.name + '/' + f.name for f in os.scandir(subdir) if not f.is_dir() and f.name.endswith(".c")]
			files += ["main.c"]
			# create CMake entry
			out_file.write(f'{"if" if first else "elseif"}(BENCHMARK STREQUAL "{subdir.name}")\n\tidf_component_register(SRCS {" ".join(files)} INCLUDE_DIRS {subdir.name} .)\n')
			first = False
		out_file.write('else()\n\tmessage(FATAL_ERROR "no matching benchmark found, value was: ${BENCHMARK}")\nendif()')
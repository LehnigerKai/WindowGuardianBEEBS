import numpy as np
from tabulate import tabulate

def to_table():
	"""Reads the benchmark results from the readme to create a table.
	
	This function is used to create a table in latex format for a paper.
	Therefore, all parameters are hardcoded, but may be modified if someone wants a different plot.

	:returns: none
	:rtype: None
	"""
	
	# read data from README
	# adjust skip_header to the line "|---|---|---|" for the results table
	with open("README.MD") as data:
		data = np.genfromtxt(data, delimiter="|", skip_header=48, dtype="str", autostrip=True)
		data = {(d[1], d[2]) : int(d[3]) for d in data}
		print(data)
	# all the benchmarks that should be included
	rows = ["aha-compress","aha-mont64","bs","bubblesort","cnt","compress","cover","crc","crc32","cubic","dijkstra","dtoa","duff","edn","expint","fac","fasta","fdct","fibcall","fir","frac","huffbench","insertsort","janne_complex","jfdctint","lcdnum","levenshtein","ludcmp","mergesort","minver","nbody","ndes","nettle-aes","nettle-arcfour","nettle-des","nettle-md5","nettle-sha256","newlib-exp","newlib-log","newlib-mod","newlib-sqrt","ns","nsichneu","picojpeg","prime","qrduino","qsort","qurt","recursion","rijndael","sglib-arraybinsearch","sglib-hashtable","sglib-listsort","sglib-queue","sglib-rbtree","slre","sqrt","st","statemate","stb_perlin","stringsearch1","strstr","tarai","ud","whetstone","wikisort"]
	
	# sort by largest overhead for first method
	rows = sorted(rows, key=lambda x : data[(x,"0")] / data[(x,"1")])
	
	# all test cases
	columns = [("0"),("1"), ("2")]
	
	# reference value for relative overhead
	reference = ("0")
	out = []
	for row in rows:
		try:
			count = data[(row, "-1")]
		except KeyError:
			count = "-"
		line = [f"{row} ({count})"]
		for column in columns:
			try:
				entry = data[(row,*column)]
				if column != reference:
					entry = f"{entry:,} ({entry / data[(row,*reference)] - 1:+.3%})"
				else:
					entry = f"{entry:,}"
				line.append(entry)
			except KeyError:
				line.append("")
		out.append(line)
	# add averages
	line = ["total"]
	for column in columns:
		try:
			entry = sum([data[(row, *column)] for row in rows])
			if column != reference:
				entry = f"{entry:,} ({entry / ref - 1:+.3%})"
			else:
				ref = entry
				entry = f"{entry:,}"
			line.append(entry)
		except KeyError:
			line.append("")
	out.append(line)


	print(tabulate(out, headers=["Benchmark", "Regular", "Re-encryption", "Ciphering"], tablefmt="latex"))



if __name__ == '__main__':
	to_table()
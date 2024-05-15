import argparse
import serial
import os
import subprocess

def benchmark(port, export_file, benchmark, method):
	"""Run a single benchmark instance with the given parameters.

	Starts a process to build and flash a benchmark application with the given configuration parameters.
	Afterwards it creates a serial connection and waits for the result of the benchmark.
	
	:param str port: serial port of connected ESP32 device
	:param str export_file: Path to export.sh or export.bat in your local ESP-IDF installation
	:param str benchmark: name of the benchmark appication
	:param method str: method to benchmark (-1: only count overflows, 0: default, 1: re-encryption, 2: ciphering)
	:returns: benchmark result
	:rtype: str
	"""
	subprocess.run(f"{export_file} && idf.py -DBENCHMARK={benchmark} -DSEC_METHOD={method} build && idf.py -p {port} flash", shell=True)

	with serial.Serial(port, 115200) as ser:
		while True:
			try:
				line = ser.readline().decode("utf-8")
				if line.startswith("Result"):
					return line.split()[-1]
			except UnicodeDecodeError:
				continue

if __name__ == "__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument("-p", "--port", type=str)
	parser.add_argument("-e", "--export_file", type=str, help="path to export script to initialize ESP IDF environment")
	parser.add_argument("-r", "--results", type=str, help="file to save results")
	parser.add_argument("-b", "--benchmarks", nargs="*", help="Select a number BEEBS benchmarks to run", default=[])
	parser.add_argument("-m", "--methods", nargs="*", help="Select security methods ", default=[-1,0,1,2])


	args = parser.parse_args()

	with open(args.results, "w") as res:
		for bm in ([d.name for d in os.scandir("main") if d.is_dir()] if len(args.benchmarks) == 0 else args.benchmarks):
			for m in args.methods:
				result = benchmark(args.port, args.export_file, bm, m)
				res.write(f"|{bm}|{m}| {result}|\n")
				res.flush()
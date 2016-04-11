from Server.server import main

def run(environ, start_response):
	print(dir())
	main()


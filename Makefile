test:
	docker build -t dotnet-build . 
	docker run -it dotnet-build

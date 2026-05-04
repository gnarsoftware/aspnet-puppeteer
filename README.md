# aspnet-puppeteer-azure

Base docker image for running PuppeteerSharp in Asp.Net Core. Includes SSH support for Kudu.

# Usage

## With SSH

### Dockerfile
```docker
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
# build your app; publish to /app

FROM elite747/aspnet-puppeteer-azure:10.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["./entrypoint.sh"]
```

### entrypoint.sh
```sh
#!/bin/sh
set -e
service ssh start
dotnet YourApp.dll
```

Replace YourApp with the appropriate file name for your program.

## Without SSH

### Dockerfile
```docker
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
# build your app; publish to /app

FROM elite747/aspnet-puppeteer-azure:10.0
WORKDIR /app
COPY --from=publish /app ./
ENTRYPOINT ["dotnet", "YourApp.dll"]
```

Replace YourApp with the appropriate file name for your program.

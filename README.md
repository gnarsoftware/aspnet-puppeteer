# aspnet-puppeteer

Base docker image for running PuppeteerSharp in Asp.Net Core. Includes SSH support for Kudu.

# Usage

In your app, the ExecutablePath param can be read from the `PUPPETEER_EXECUTABLE_PATH` environment variable.

Sandboxing must be turned off with the `--no-sandbox` arg.

Example:
```cs
var browser = await Puppeteer.LaunchAsync(
    new LaunchOptions
    {
        Headless = true,
        ExecutablePath = Environment.GetEnvironmentVariable("PUPPETEER_EXECUTABLE_PATH")!,
        Args = ["--no-sandbox"],
    }
);
```

> [!CAUTION]
> Be aware of the security implications of running chrome without sandboxing.
> This should only be used to load html that you trust.

## With SSH

### Dockerfile
```docker
# build your app
# example:
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
COPY . .
RUN dotnet publish -o /app

FROM gnarsoftware/aspnet-puppeteer:10.0
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
# build your app
# example:
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
COPY . .
RUN dotnet publish -o /app

FROM gnarsoftware/aspnet-puppeteer:10.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "YourApp.dll"]
```

Replace YourApp with the appropriate file name for your program.

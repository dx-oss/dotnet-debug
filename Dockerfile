# STAGE0
FROM dxdx/docker-builder-dotnet:3.1 as builder
COPY . /app/
WORKDIR /app/timezone
RUN dotnet build
RUN dotnet publish -r linux-x64 --no-self-contained

# STAGE1
FROM mcr.microsoft.com/dotnet/core/sdk:3.1
COPY --from=builder /app/timezone/bin/Debug/netcoreapp3.1/linux-x64/publish /app/timezone
COPY --from=builder /sbin/tini /sbin/tini
COPY --from=builder /usr/bin/fwatchdog /usr/bin/fwatchdog
WORKDIR /app
EXPOSE 8080
USER root

CMD ["tini", "--", "dotnet", "timezone/timezone.dll"]

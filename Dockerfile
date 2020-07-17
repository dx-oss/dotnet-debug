# STAGE0
FROM dxdx/docker-builder-dotnet:3.1 as builder
COPY . /app/
WORKDIR /app/timezone
RUN dotnet build
WORKDIR /app/timezone/bin/Debug
RUN mkdir /app/out
RUN mv netcoreapp3.1 /app/out/timezone

# STAGE1
FROM mcr.microsoft.com/dotnet/core/sdk:3.1
# COPY FROM STAGE0 SO WE DONT TAKE WITH SECRETS
COPY --from=builder /app/out/timezone /app/timezone
COPY --from=builder /sbin/tini /sbin/tini
COPY --from=builder /usr/bin/fwatchdog /usr/bin/fwatchdog

WORKDIR /app

EXPOSE 8080

USER root

CMD ["tini", "--", "dotnet", "timezone/timezone.dll"]

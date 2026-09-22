# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0-windowsservercore-ltsc2022 AS build
WORKDIR /src

# Copy project file
COPY ["WebApplication1.csproj", "./"]

# Restore dependencies
RUN dotnet restore "WebApplication1.csproj"

# Copy source code
COPY . .

# Build
RUN dotnet build "WebApplication1.csproj" -c Release -o /app/build

# Publish stage
FROM build AS publish
RUN dotnet publish "WebApplication1.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0-windowsservercore-ltsc2022 AS final
WORKDIR /app

COPY --from=publish /app/publish .

EXPOSE 8080

ENTRYPOINT ["dotnet", "WebApplication1.dll"]

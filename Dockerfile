# Use the .NET SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app
EXPOSE 8080

EXPOSE 8081

# Copy csproj and restore as distinct layers
COPY ./App ./App
RUN dotnet restore  ./App/App.csproj

# Copy everything else and build the application
COPY ./App/* ./
RUN dotnet publish ./App/App.csproj -c Release -o out

# Build ASP image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./



# Set the entry point for the application
ENTRYPOINT ["dotnet", "App.dll"]

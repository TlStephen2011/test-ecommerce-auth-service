# Use a multi-stage build to reduce image size
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy csproj and restore as distinct layers
COPY ["API_Identity/API_Identity.csproj", "API_Identity/"]
COPY ["API_Common/API_Common.csproj", "API_Common/"]
RUN dotnet restore "API_Identity/API_Identity.csproj"
RUN dotnet restore "API_Common/API_Common.csproj"

# Copy the rest of the source code
COPY . .
RUN dotnet build "API_Identity/API_Identity.csproj" -c Release -o /app/build
RUN dotnet build "API_Common/API_Common.csproj" -c Release -o /app/build

# Publish the application
WORKDIR /src/API_Identity
FROM build AS publish
RUN dotnet publish "API_Identity.csproj" -c Release -o /app/publish

# Final stage: create the runtime image
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app

ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:5000

# Copy published output from publish stage
COPY --from=publish /app/publish .

# Expose the necessary port
EXPOSE 5000

# Start the app
CMD ["dotnet", "API_Identity.dll"]
# Use the official image as a parent image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Use SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["ASP.NET_WebAPI6/ASP.NET_WebAPI6.csproj", "ASP.NET_WebAPI6/"]
RUN dotnet restore "ASP.NET_WebAPI6/ASP.NET_WebAPI6.csproj"
COPY . .
WORKDIR "/src/ASP.NET_WebAPI6"
RUN dotnet build "ASP.NET_WebAPI6.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ASP.NET_WebAPI6.csproj" -c Release -o /app/publish

# Build runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ASP.NET_WebAPI6.dll"]

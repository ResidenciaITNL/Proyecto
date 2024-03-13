#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Sistema.csproj", "./"]
RUN dotnet restore "Sistema.csproj"
COPY . .
WORKDIR "/src"
RUN dotnet build "Sistema.csproj" -c Release -o /app/build

RUN dotnet tool install --global dotnet-ef --version 6.0.0
ENV PATH="${PATH}:/root/.dotnet/tools"

FROM build AS publish
RUN dotnet publish "Sistema.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Sistema.dll"]
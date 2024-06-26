FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
WORKDIR /App

COPY . ./

RUN dotnet restore
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:7.0
ENV ASPNETCORE_ENVIRONMENT=Development
WORKDIR /App
COPY --from=build-env /App/out .

EXPOSE 80
ENTRYPOINT ["dotnet", "SampleWebApiAspNetCore.dll"]
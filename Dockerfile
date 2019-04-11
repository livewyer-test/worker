FROM microsoft/dotnet:2.0.0-runtime AS base
WORKDIR /code
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.0.0-sdk AS build
WORKDIR /code

ADD src/Worker /code/src/Worker

RUN dotnet restore -v minimal src/Worker

FROM build AS publish
WORKDIR /code

RUN dotnet publish -c Release -o "./" "src/Worker/" 

FROM base AS final
WORKDIR /code
COPY --from=publish /code .
ENTRYPOINT ["dotnet", "src/Worker/Worker.dll"]
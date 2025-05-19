# building
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

# Copiamos todos los .csproj necesarios
COPY MoneyBankService/MoneyBankService.Api/MoneyBankService.Api.csproj MoneyBankService.Api/
COPY MoneyBankService/MoneyBankService.Application/MoneyBankService.Application.csproj MoneyBankService.Application/
COPY MoneyBankService/MoneyBankService.Domain/MoneyBankService.Domain.csproj MoneyBankService.Domain/
COPY MoneyBankService/MoneyBankService.Infrastructure/MoneyBankService.Infrastructure.csproj MoneyBankService.Infrastructure/
COPY MoneyBankService/MoneyBankService.Frontend/MoneyBankService.Frontend.csproj MoneyBankService.Frontend/

# Restauramos dependencias
RUN dotnet restore MoneyBankService.Api/MoneyBankService.Api.csproj

# Copiamos el resto del código fuente
COPY . .


RUN dotnet publish MoneyBankService.Frontend/MoneyBankService.Frontend.csproj -c Release -o /frontend-dist


RUN dotnet publish MoneyBankService.Api/MoneyBankService.Api.csproj -c Release -o /app/publish


RUN rm -rf /app/publish/wwwroot && mkdir -p /app/publish/wwwroot && \
    cp -r /frontend-dist/wwwroot/* /app/publish/wwwroot/

# runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .

ENTRYPOINT ["dotnet", "MoneyBankService.Api.dll"]

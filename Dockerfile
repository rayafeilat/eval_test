FROM mcr.microsoft.com/dotnet/sdk:10.0@sha256:3fcf6f1e809c0553f9feb222369f58749af314af6f063f389cbd2f913b4ad556 AS build

WORKDIR /App

# Copy everything
COPY /home/raya/eval_test/others ./
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:10.0@sha256:b4bea3a52a0a77317fa93c5bbdb076623f81e3e2f201078d89914da71318b5d8

WORKDIR /App

#COPY /home/raya/eval_test/properties  ./
#COPY /home/raya/eval_test/bin  ./
#COPY /home/raya/eval_test/obj  ./
# am not convinced with this but gonna keep it for now 
ENTRYPOINT ["dotnet", "/home/raya/eval_test"]

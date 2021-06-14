import ballerina/http;
import ballerina/log;
import ballerinax/covid19;

service / on new http:Listener(8090) {
    resource function get summery(http:Caller caller, http:Request request) returns error? {
        
        string country = "USA";
        covid19:Client covid19Client = check new covid19:Client();
        covid19:CovidCountry statusByCountry = check covid19Client->getStatusByCountry(country, "true", "false", "true", 
        "false");
        decimal todayCases = statusByCountry?.todayCases ?: 0d;
        decimal todayDeaths = statusByCountry?.todayDeaths ?: 0d;
        decimal todayRecovered = statusByCountry?.todayRecovered ?: 0d;
        decimal population = statusByCountry?.population ?: 0d;

        log:printInfo("extracted data", TodayCases = todayCases, TodayDeaths = todayDeaths, TodayRecovered = 
        todayRecovered, Population = population);

        population = population / 1000000;
        decimal newCasesPerMillion = todayCases / population;
        decimal newDeathsPerMillion = todayDeaths / population;
        decimal newRecoveriesPerMillion = todayRecovered / population;

        log:printInfo("summary", NewCasesPerMillion = newCasesPerMillion, NewDeathsPerMillion = newDeathsPerMillion, 
        NewRecoveriesPerMillion = newRecoveriesPerMillion);

        http:Response resp = new;
        resp.statusCode = 200;
        resp.setJsonPayload({
           "NewCasesPerMillion" : newCasesPerMillion,
           "NewDeathsPerMillion" : newDeathsPerMillion,
           "NewRecoveriesPerMillion" : newRecoveriesPerMillion
        });
        check caller->respond(resp);
    }
}

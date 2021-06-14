import ballerina/log;
    import ballerinax/covid19;
import wso2/choreo.sendemail as email;


configurable string country = ?;

public function main() returns error? {
    covid19:Client covid19Client = check new covid19:Client();
    covid19:CovidCountry statusByCountry = check covid19Client->getStatusByCountry(country, "true", "false", "true", "false");
    decimal todayCases = statusByCountry?.todayCases ?: 0d;
    decimal todayDeaths = statusByCountry?.todayDeaths ?: 0d;
    decimal todayRecovered = statusByCountry?.todayRecovered ?: 0d;
    decimal population = statusByCountry?.population ?: 0d;

    log:printInfo("extracted data", TodayCases = todayCases, 
                             TodayDeaths = todayDeaths, 
                             TodayRecovered = todayRecovered, Population = population);

    population = population / 1000000;
    decimal newCasesPerMillion = todayCases / population;
    decimal newDeathsPerMillion = todayDeaths / population;
    decimal newRecoveriesPerMillion = todayRecovered / population;

    log:printInfo("summary", NewCasesPerMillion = newCasesPerMillion, 
                             NewDeathsPerMillion = newDeathsPerMillion, 
                             NewRecoveriesPerMillion = newRecoveriesPerMillion);

    
    string emailBody = "Email Body";
    email:Client emailSender = check new();
    string emailId = check emailSender->sendEmail("ramith@wso2.com",
                           "Daily Covid Status in USA",
                          emailBody);
}
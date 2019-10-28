#r "Newtonsoft.Json"

using System;
using System.Net;
using System.Security.Cryptography;

// OMS STATIC VARIABLES

// Update customerId to your Operations Management Suite workspace ID
static string customerId = "xxxx";

// For sharedKey, use either the primary or the secondary Connected Sources client authentication key   
static string sharedKey = "xxxx";

// LogName is name of the event type that is being submitted to Log Analytics
static string LogName = "Dev";

// You can use an optional field to specify the timestamp from the data. If the time field is not specified, Log Analytics assumes the time is the message ingestion time
static string TimeStampField = "";

public static async Task<HttpResponseMessage> Run(HttpRequestMessage req, TraceWriter log)
{
    log.Info("C# HTTP trigger function processed a request.");
    dynamic data = await req.Content.ReadAsStringAsync();
    string dataString = data.ToString();
    log.Info("Incoming Data is: " + dataString );

    // Create a hash for the API signature
    var datestring = DateTime.UtcNow.ToString("r");
    string stringToHash = "POST\n" + dataString.Length + "\napplication/json\n" + "x-ms-date:" + datestring + "\n/api/logs";
    string hashedString = BuildSignature(stringToHash, sharedKey);
    string signature = "SharedKey " + customerId + ":" + hashedString;

    log.Info("Posting Data: " + dataString);

    string postDataResponce = PostData(signature, datestring, dataString);

    log.Info("Posted Data!");
    log.Info("Posted Data Response: " + postDataResponce);

     return postDataResponce == null
        ? req.CreateResponse(HttpStatusCode.BadRequest, "Error")
        : req.CreateResponse(HttpStatusCode.OK, "Response: " + postDataResponce);
}

// Build the API signature
public static string BuildSignature(string message, string secret)
{
    var encoding = new System.Text.ASCIIEncoding();
    byte[] keyByte = Convert.FromBase64String(secret);
    byte[] messageBytes = encoding.GetBytes(message);
    using (var hmacsha256 = new HMACSHA256(keyByte))
    {
        byte[] hash = hmacsha256.ComputeHash(messageBytes);
        return Convert.ToBase64String(hash);
    }
}

// Send a request to the POST API endpoint
public static string PostData(string signature, string date, string json)
{
    string url = "https://"+ customerId + ".ods.opinsights.azure.com/api/logs?api-version=2016-04-01";
    using (var client = new WebClient())
    {
        client.Headers.Add(HttpRequestHeader.ContentType, "application/json");
        client.Headers.Add("Log-Type", LogName);
        client.Headers.Add("Authorization", signature);
        client.Headers.Add("x-ms-date", date);
        client.Headers.Add("time-generated-field", TimeStampField);
        string reply = client.UploadString(new Uri(url), "POST", json);
        return ("reply: " + reply + "URL: " + url +  " Data: " + json);
    }
}
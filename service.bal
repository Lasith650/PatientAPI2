import ballerina/http;
import ballerina/log;
import wso2healthcare/healthcare.fhir.r4;

final r4:ResourceAPIConfig apiConfig = {
    resourceType: "Patient",
    profiles: ["http://hl7.org/fhir/StructureDefinition/Patient"],
    defaultProfile: "http://hl7.org/fhir/StructureDefinition/Patient",
    searchParameters: [
        {
            name: "active",
            active: true
        },
        {
            name: "address",
            active: true
        },
        {
            name: "address-city",
            active: true
        },
        {
            name: "address-country",
            active: true
        },
        {
            name: "address-postalcode",
            active: true
        },
        {
            name: "address-state",
            active: true
        },
        {
            name: "address-use",
            active: true
        },
        {
            name: "birthdate",
            active: true
        },
        {
            name: "death-date",
            active: true
        },
        {
            name: "deceased",
            active: true
        },
        {
            name: "email",
            active: true
        },
        {
            name: "family",
            active: true
        },
        {
            name: "gender",
            active: true
        },
        {
            name: "general-practitioner",
            active: true
        },
        {
            name: "given",
            active: true
        },
        {
            name: "identifier",
            active: true
        },
        {
            name: "language",
            active: true
        },
        {
            name: "link",
            active: true
        },
        {
            name: "name",
            active: true
        },
        {
            name: "organization",
            active: true
        },
        {
            name: "phone",
            active: true
        },
        {
            name: "phonetic",
            active: true
        },
        {
            name: "telecom",
            active: true
        }
    ],
    operations: [],
    serverConfig: ()
};

@http:ServiceConfig {
    interceptors: [
        new r4:FHIRReadRequestInterceptor(apiConfig), 
        new r4:FHIRCreateRequestInterceptor(apiConfig), 
        new r4:FHIRSearchRequestInterceptor(apiConfig),
        new r4:FHIRRequestErrorInterceptor(),
        new r4:FHIRResponseInterceptor(apiConfig),
        new r4:FHIRResponseErrorInterceptor()
    ]
}
service /fhir/r4 on new http:Listener(9090) {

    // Search the resource type based on some filter criteria
    resource function get Patient (http:RequestContext ctx, http:Request request) returns json|xml|r4:FHIRError {
        log:printDebug("FHIR interaction : search");
        // Retrieve request FHIR context
        r4:FHIRContext fhirContext = check r4:getFHIRContext(ctx);
        // Retrieve pre-processed search parameters
        map<r4:RequestSearchParameter[]> & readonly searchParameters = fhirContext.getSearchParameters();
        log:printDebug("Search Parameters : " + searchParameters.toBalString());
        // Instantiate response bundle
        r4:Bundle responseBundle = {
            'type: r4:BUNDLE_TYPE_SEARCHSET
        };

        // Populate Patient resources
        r4:Patient patient = {
            id: "1"
        };
        // add created patient resource to the bundle
        addPatientToBundle(patient, responseBundle, fhirContext);

        // set Patient search response bundle
        check setPatientSearchResponse(responseBundle, ctx);
        log:printDebug("[END]FHIR interaction : search");
        return;
    }

    // Read the current state of the resource
    resource function get Patient/[string id] (http:RequestContext ctx) returns json|xml|r4:FHIRError {
        log:printDebug("[START]FHIR interaction : read");

        // Populate Patient resources
        r4:Patient patient = {
            id: id
        };
        
        // set Patient read response resource
        check setPatientReadResponse(patient, ctx);
        log:printDebug("[END]FHIR interaction : read");
        return;
    }

    // Create a new resource with a server assigned id
    resource isolated function post Patient (http:RequestContext ctx, http:Request request) returns json|r4:FHIRError {
        log:printDebug("[START] Patient Create API Resource");

        // retrieve Patient resource in the request payload
        r4:Patient patient = check getPatientRequestResource(ctx);
        log:printDebug("Request:" + patient.toBalString());
        
        log:printDebug("[END] Patient Create API Resource");
        return {};
    }
}

%dw 2.0

type CATEGORY = "Exception" | "Standard"

type LOGMSG = {  
	message: String | Null,
    transactionId: String,
    appName: String | Null,
    flowName: String | Null,
    businessProcessName: String | Null,
    category: CATEGORY,
    originatingApplication: String | Null,
    destinationApplication: String | Null,
    applicationErrorCode: String | Null,
    errorCodeReturnedByDestination: String | Null,
    severity: String | Null,
    errorCode: String | Null,
    errorDescription: String | Null,
    elapsedTime: DateTime | Null,
    metadata: Object | Null
}

fun composeMsg(logMsg: LOGMSG) = {
	
    (message: logMsg.message) if(!isBlank(logMsg.message)),
    (transactionId: logMsg.transactionId) if(!isBlank(logMsg.transactionId)),
    (appName: logMsg.appName) if(!isBlank(logMsg.appName)),
    (flowName: logMsg.flowName) if(!isBlank(logMsg.flowName)),
    (businessProcessName: logMsg.businessProcessName) if(!isBlank(logMsg.businessProcessName)),
    (category: logMsg.category) if(!isBlank(logMsg.category)),
    (originatingApplication: logMsg.originatingApplication) if(!isBlank(logMsg.originatingApplication)),
    (destinationApplication: logMsg.destinationApplication) if(!isBlank(logMsg.destinationApplication)),
    (applicationErrorCode: logMsg.applicationErrorCode) if(!isBlank(logMsg.applicationErrorCode) and logMsg.category == "Exception"),
    (errorCodeReturnedByDestination: logMsg.errorCodeReturnedByDestination) if(!isBlank(logMsg.errorCodeReturnedByDestination) and logMsg.category == "Exception"),
    (severity: logMsg.severity) if(!isBlank(logMsg.severity) and logMsg.category == "Exception"),
    (errorCode: logMsg.errorCode) if(!isBlank(logMsg.errorCode) and logMsg.category == "Exception"),
    (errorDescription: logMsg.errorDescription) if(!isBlank(logMsg.errorDescription) and logMsg.category == "Exception"),
    (elapsedTime: diff(logMsg.elapsedTime) ++ ' ms') if(!isBlank(logMsg.elapsedTime)),
   	(metadata: logMsg.metadata) if(logMsg.metadata != null)
   
}

fun logText(message : String, flowName: String, logMsg: LOGMSG) = (
	logText(message, replace(logMsg, 'flowName', flowName))
)

fun logText(message : String, logMsg: LOGMSG) = (
	logText(replace(logMsg, 'message', message))
)

fun logText(logMsg: LOGMSG) = (
	logText(composeMsg(logMsg))
)


fun log(message : String, flowName: String, logMsg: LOGMSG) = (
	log(message, replace(logMsg, 'flowName', flowName))
)

fun log(message : String, logMsg: LOGMSG) = (
	log(replace(logMsg, 'message', message))
)

fun log(logMsg: LOGMSG) = (
	composeMsg(logMsg)
)



fun logText(data: Object) = (
    if(isEmpty(data)) 
        ""
    else
        (keysOf(data) reduce(key, acc= null) -> (
            if(acc == null) 
                key ++ '=[' ++ data[key] ++ ']'
            else 
                acc ++ ', ' ++ key ++ '=[' ++ data[key] ++ ']'
            ))
)

fun replace(obj, k, v) = (
    obj mapObject ((value, key, index) -> {
        ((key): value) if(!(key ~= k)),
        ((key): v) if((key ~= k)),
    })
)

fun diff(p : DateTime) = (
    if(p == null or isEmpty(p)) 
        0
    else
        (now() - p) as Number {unit: "milliseconds"}
)

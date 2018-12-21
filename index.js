var Connection = require('tedious').Connection;  
var Request = require('tedious').Request;  
var TYPES = require('tedious').TYPES;  

var config = {  
    userName: 'Chatbot',  
    password: '!QAZ2wsx',  
    server: 'KSQLGTNLDEV01',  
    // If you are on Microsoft Azure, you need this:  
    //options: {encrypt: true, database: 'AdventureWorks'}  
};  
var connection = new Connection(config);  
connection.on('connect', function(err) {  
// If no error, then good to proceed.  

    if (!err)
    {
        console.log("Connected");
    }

    request = new Request("SELECT TOP (50) [ReasonNotAssignedID] ,[ReasonNotAssignedDescription] FROM Assignment_V3_0.dbo.ReasonNotAssigned;", function(err) {  
        if (err) {  
            console.log(err);}  
        });  
        var result = "";  
        request.on('row', function(columns) {  
            columns.forEach(function(column) {  
              if (column.value === null) {  
                console.log('NULL');  
              } else {  
                result+= column.value + " ";  
              }  
            });  
            console.log(result);  
            result ="";  
        });  

        request.on('done', function(rowCount, more) {  
            console.log(rowCount + ' rows returned');  
        });  
        
        connection.execSql(request);  
});  


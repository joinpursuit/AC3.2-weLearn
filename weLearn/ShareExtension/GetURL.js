var GetURL = function() {};
GetURL.prototype = {
    run: function(arguments) {
        arguments.completionFunction({"URL": document.URl});
    }
};

var ExtensionPreprocessingJS = new GetURL;

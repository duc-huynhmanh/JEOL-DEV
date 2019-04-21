public with sharing class JEOLAsia_ToolQTSpecificationsCtrl {

    public String textToConvert{get; set;}
    public String textConverted{get; set;}
    public Integer textToConvertLength{get; set;}

    public JEOLAsia_ToolQTSpecificationsCtrl() {
        textToConvertLength = 0;
    }
    
    public void convertText() {

        textConverted = '';

        String textToConvertTmp = textToConvert.replace('\r\n', '\n').replace('\r', '\n');

        boolean fIsInsideQuote = false;

        for(integer i = 0; i < textToConvert.length(); i++) {
            if (textToConvert.substring(i, i + 1) == '"') {
                fIsInsideQuote = !fIsInsideQuote;
            }
            if (fIsInsideQuote && textToConvert.substring(i, i + 1) == '\n') {
                textConverted = textConverted + '<BR/>';
            }
            textConverted = textConverted + textToConvert.substring(i, i + 1);
        }

    }

    public void updateTextToConvertLength() {

        if (textToConvert == NULL) {
            textToConvertLength =  0;
        } else {
            textToConvertLength = textToConvert.length();
        }
    }
}
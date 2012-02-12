#include "astyle.h"
#include "asstreamiterator.h"
#include <stdlib.h>

#ifndef BUILD_DLL
  #include <stdio.h>
#endif

#define CHECK_BIT(value, shift)\
    ((( (value) >> (shift) ) & 1) == 1)

using namespace astyle;

typedef struct {
    char * text;
    FormatStyle style;
    BracketMode bracket_format;
    unsigned int properties;
    int tab_width;
    int space_width;
    bool useTabChar;
} ASTyle;


const char * AStyleProperties[] = 
{
    "AddBrackets",
	"AddOneLineBrackets",
	"BreakClosingHeaderBrackets",
	"BreakBlocks",
	"BreakClosingHeaderBlocks",
	"BreakElseIfs",
	"BreakOneLineBlocks",
	"DeleteEmptyLines",
	"IndentCol1Comments",
	"OperatorPadding",
	"ParensOutsidePadding",
	"ParensInsidePadding",
	"ParensHeaderPadding",
	"ParensUnPadding",
	"SingleStatements",
	"TabSpaceConversion",
    "BracketIndent",
    "ClassIndent",
    "SwitchIndent",
    "NamespaceIndent",
    "BlockIndent"
};

#ifdef __cplusplus
extern "C" {
#endif


EXPORT void AStyleSetProperty(ASTyle * style, const char * property, int value);
    
EXPORT ASTyle * AStyleCreate()
{
    ASTyle * style = (ASTyle*)malloc(sizeof(ASTyle));
    if(style == NULL)
        return NULL;
    style->text = NULL;
    style->useTabChar = false;
    style->tab_width = 4;
    style->space_width = 4;
    style->style = STYLE_NONE;
    style->bracket_format = NONE_MODE;
    style->properties = 0;
    AStyleSetProperty(style, "OperatorPadding", 1);
    return style;
}

EXPORT void AStyleFree(ASTyle * style)
{
    if(style->text != NULL)
        free(style->text);
    free(style);
}

EXPORT void AStyleSetStyle(ASTyle * style, int fstyle)
{
    style->style = (FormatStyle)fstyle;
}

EXPORT void AStyleSetBracketFormat(ASTyle * style, int bformat)
{
    style->bracket_format = (BracketMode)bformat;
}

EXPORT void AStyleUseTabChar(ASTyle * style, int value)
{
    style->useTabChar = (value == 1);
}

EXPORT void AStyleSetTabWidth(ASTyle * style, int width)
{
    style->tab_width = width;
}

EXPORT void AStyleSetSpaceWidth(ASTyle * style, int width)
{
    style->space_width = width;
}

EXPORT void AStyleSetProperty(ASTyle * style, const char * property, int value)
{
    int count = sizeof(AStyleProperties) / sizeof(const char*);
    int i;
    for(i = 0; i < count; i++)
    {
        if(strcmp(AStyleProperties[i], property) == 0)
        {
            if(value)
                style->properties |= 1 << i;
            else
                style->properties &= ~(1 << i);
            break;
        }
    }
}

EXPORT char* AStyleText(ASTyle * style)
{
    return style->text;
}

EXPORT int AStyleFormatText(ASTyle * style, const char* srcCode)
{
    ASFormatter formatter;
    
	formatter.setAddBracketsMode(CHECK_BIT(style->properties, 0));
	formatter.setAddOneLineBracketsMode(CHECK_BIT(style->properties, 1));
	formatter.setBreakClosingHeaderBracketsMode(CHECK_BIT(style->properties, 2));
	formatter.setBreakBlocksMode(CHECK_BIT(style->properties, 3));
	formatter.setBreakClosingHeaderBlocksMode(CHECK_BIT(style->properties, 4));
	formatter.setBreakElseIfsMode(CHECK_BIT(style->properties, 5));
	formatter.setBreakOneLineBlocksMode(CHECK_BIT(style->properties, 6));
	formatter.setDeleteEmptyLinesMode(CHECK_BIT(style->properties, 7));
	formatter.setIndentCol1CommentsMode(CHECK_BIT(style->properties, 8));
	formatter.setOperatorPaddingMode(CHECK_BIT(style->properties, 9));
	formatter.setParensOutsidePaddingMode(CHECK_BIT(style->properties, 10));
    formatter.setParensInsidePaddingMode(CHECK_BIT(style->properties, 11));
    formatter.setParensHeaderPaddingMode(CHECK_BIT(style->properties, 12));
    formatter.setParensUnPaddingMode(CHECK_BIT(style->properties, 13));
    formatter.setSingleStatementsMode(CHECK_BIT(style->properties, 14));
    formatter.setTabSpaceConversionMode(CHECK_BIT(style->properties, 15));
    formatter.setBracketIndent(CHECK_BIT(style->properties, 16));
    formatter.setClassIndent(CHECK_BIT(style->properties, 17));
    formatter.setSwitchIndent(CHECK_BIT(style->properties, 18));
    formatter.setNamespaceIndent(CHECK_BIT(style->properties, 19));
    formatter.setBlockIndent(CHECK_BIT(style->properties, 20));
    
    formatter.setBracketFormatMode(style->bracket_format);
    if (style->useTabChar) 
        formatter.setTabIndentation(style->tab_width, true);
    else
        formatter.setSpaceIndentation(style->space_width);
    formatter.setFormattingStyle(style->style);
    if (style->style == STYLE_JAVA) 
        formatter.setJavaStyle();
    string formattinText;
    string inText(srcCode);

    string eolChars;

    eolChars = "\r\n";

    if (inText.size() && inText[inText.size() - 1] != '\r' && 
        inText[inText.size() - 1] != '\n')
    {
        inText += eolChars;
    }

    ASStreamIterator *asi = new ASStreamIterator(inText.c_str());

    formatter.init(asi);

    int lineCounter = 0;

    while (formatter.hasMoreLines())
    {
        formattinText += formatter.nextLine();
        if (formatter.hasMoreLines())
        {
            formattinText += eolChars;
        }
        ++lineCounter;
    }
    if(style->text != NULL)
        free(style->text);
    unsigned int size = formattinText.size();
    style->text = (char*)malloc(sizeof(char) * (size + 1));
    if(style->text == NULL)
        return 1;
    memcpy(style->text, formattinText.c_str(), sizeof(char) * size);
    style->text[size] = '\0';
    return 0;
}

#ifdef __cplusplus
}
#endif

#ifndef BUILD_DLL

int main(int argc, char *argv[])
{
    
    ASTyle* as = AStyleCreate();
    AStyleFormatText(as, 
    "int main(){\r\n"
    "int a;\r\n"
    "\r\n"
    " int     b;\r\n"
    "\r\n"
    "if (a==2){\r\n"
    "a--;\r\n"
    "         }\r\n" 
    "\r\n"
    "\r\n"
    "    }\r\n"
    );
    printf("%s", AStyleText(as));
    AStyleFree(as);
    getchar();
    return 0;
}

#endif

#include "chmtools.h"
#include <assert.h>

DEFINE_GUID(ITSFHeaderGUID1, 0x7C01FD10, 0x7BAA, 0x11D0, 0x9E, 0x0C, 0x00, 0xA0, 0xC9, 0x22, 0xE6, 0xEC);
DEFINE_GUID(ITSFHeaderGUID2, 0x7C01FD11, 0x7BAA, 0x11D0, 0x9E, 0x0C, 0x00, 0xA0, 0xC9, 0x22, 0xE6, 0xEC);
CHMSignature const ITSFFileSig = { { 'I', 'T', 'S', 'F' } };

DEFINE_GUID(ITSPHeaderGUID, 0x5D02926A, 0x212E, 0x11D0, 0x9D, 0xF9, 0x00, 0xA0, 0xC9, 0x22, 0xE6, 0xEC);
CHMSignature const ITSPHeaderSig = { { 'I', 'T', 'S', 'P' } };

CHMSignature const PMGIsig = { { 'P', 'M', 'G', 'I' } };
CHMSignature const PMGLsig = { { 'P', 'M', 'G', 'L' } };

DEFINE_GUID(ITOLITLSGuid, 0x0A9007C1, 0x4076, 0x11D3, 0x87, 0x89, 0x00, 0x00, 0xF8, 0x10, 0x57, 0x54);


uint32_t GetCompressedInteger(ChmStream *Stream)
{
	uint64_t total = 0;
	int temp;
	int sanity = 0;
	
	temp = ChmStream_fgetc(Stream);
	if (temp == EOF)
		return 0;
	while (temp >= 0x80)
	{
		total <<= 7;
		total += temp & 0x7f;
		temp = ChmStream_fgetc(Stream);
		if (temp == EOF)
			return 0;
		++sanity;
		assert(sanity <= 8);
	}
	total <<= 7;
	total += temp;
	return total;
}


/*
 * returns the number of bytes written to the stream
 */
uint32_t WriteCompressedInteger(ChmStream *Stream, uint32_t number)
{
	uint64_t Buffer;
	uint32_t count = PutCompressedInteger(&Buffer, number);
	return ChmStream_Write(Stream, &Buffer, count);
}


uint32_t PutCompressedInteger(void *Buffer, uint32_t number)
{
	int bit;
	uint32_t mask;
	uint8_t *buf;
	uint32_t TheEnd = 0;
	
	buf = (uint8_t *)Buffer;
	bit = 28;
	for (;;)
	{
		mask = (uint32_t)0x7f << bit;
		if ((bit == 0) || ((number & mask) != 0))
			break;
		bit -= 7;
	}
	for (;;)
	{
		*buf = (uint8_t)(((number >> bit) & 0x7f));
		if (bit == 0)
			break;
		*buf++ |= 0x80;
		bit -= 7;
		++TheEnd;
	}
	++TheEnd;
	
	if (TheEnd > 8)
	{
		CHM_DEBUG_LOG(0, "%u WRITE_COMPRESSED_INTEGER too big!: %d\n", number, TheEnd);
	}
	return TheEnd;
}


int ChmCompareText(const char *S1, const char *S2)
{
	return strcasecmp(S1, S2);
}


enum {
	CODEPAGE_ANSI_DEFAULT = 0,
	CODEPAGE_OEM_DEFAULT = 1,
	CODEPAGE_ANSI_CENTRAL_EUROPE = 1250,
	CODEPAGE_ANSI_CYRILLIC = 1251,
	CODEPAGE_ANSI_LATIN1 = 1252,
	CODEPAGE_ANSI_GREEK = 1253,
	CODEPAGE_ANSI_TURKISH = 1254,
	CODEPAGE_ANSI_HEBREW = 1255,
	CODEPAGE_ANSI_ARABIC = 1256,
	CODEPAGE_ANSI_BALTIC = 1257,
	CODEPAGE_ANSI_VIETNAMESE = 1258,
	CODEPAGE_OEM_THAI = 874,
	CODEPAGE_OEM_JAPANESE = 932,
	CODEPAGE_OEM_SIMPLIFIED_CHINESE = 936,
	CODEPAGE_OEM_KOREAN = 949,
	CODEPAGE_OEM_TRADITIONAL_CHINESE = 950,
	CODEPAGE_KOREAN_JOHAB = 1361,
	CODEPAGE_ISO_8859_14 = 28604
};

static struct lcid_string {
	LCID lcid;
	unsigned int codepage;
	const char *lcid_string;
} const lcid_strings[] = {
	{ MAKELANGID(LANG_CHINESE, SUBLANG_NEUTRAL), CODEPAGE_OEM_SIMPLIFIED_CHINESE, "Chinese" },
	{ MAKELANGID(LANG_ENGLISH, SUBLANG_NEUTRAL), CODEPAGE_ANSI_LATIN1, "English" },
	{ MAKELANGID(LANG_ARABIC, SUBLANG_ARABIC_SAUDI_ARABIA), CODEPAGE_ANSI_ARABIC, "Arabic (Saudi Arabia)" },
	{ MAKELANGID(LANG_ARABIC, SUBLANG_ARABIC_IRAQ), CODEPAGE_ANSI_ARABIC, "Arabic (Iraq)" },
	{ MAKELANGID(LANG_ARABIC, SUBLANG_ARABIC_EGYPT), CODEPAGE_ANSI_ARABIC, "Arabic (Egypt)" },
	{ MAKELANGID(LANG_ARABIC, SUBLANG_ARABIC_LIBYA), CODEPAGE_ANSI_ARABIC, "Arabic (Libya)" },
	{ MAKELANGID(LANG_ARABIC, SUBLANG_ARABIC_ALGERIA), CODEPAGE_ANSI_ARABIC, "Arabic (Algeria)" },
	{ MAKELANGID(LANG_ARABIC, SUBLANG_ARABIC_MOROCCO), CODEPAGE_ANSI_ARABIC, "Arabic (Morocco)" },
	{ MAKELANGID(LANG_ARABIC, SUBLANG_ARABIC_TUNISIA), CODEPAGE_ANSI_ARABIC, "Arabic (Tunisia)" },
	{ MAKELANGID(LANG_ARABIC, SUBLANG_ARABIC_OMAN), CODEPAGE_ANSI_ARABIC, "Arabic (Oman)" },
	{ MAKELANGID(LANG_ARABIC, SUBLANG_ARABIC_YEMEN), CODEPAGE_ANSI_ARABIC, "Arabic (Yemen)" },
	{ MAKELANGID(LANG_ARABIC, SUBLANG_ARABIC_SYRIA), CODEPAGE_ANSI_ARABIC, "Arabic (Syria)" },
	{ MAKELANGID(LANG_ARABIC, SUBLANG_ARABIC_JORDAN), CODEPAGE_ANSI_ARABIC, "Arabic (Jordan)" },
	{ MAKELANGID(LANG_ARABIC, SUBLANG_ARABIC_LEBANON), CODEPAGE_ANSI_ARABIC, "Arabic (Lebanon)" },
	{ MAKELANGID(LANG_ARABIC, SUBLANG_ARABIC_KUWAIT), CODEPAGE_ANSI_ARABIC, "Arabic (Kuwait)" },
	{ MAKELANGID(LANG_ARABIC, SUBLANG_ARABIC_UAE), CODEPAGE_ANSI_ARABIC, "Arabic (U.A.E.)" },
	{ MAKELANGID(LANG_ARABIC, SUBLANG_ARABIC_BAHRAIN), CODEPAGE_ANSI_ARABIC, "Arabic (Bahrain)" },
	{ MAKELANGID(LANG_ARABIC, SUBLANG_ARABIC_QATAR), CODEPAGE_ANSI_ARABIC, "Arabic (Qatar)" },
	{ MAKELANGID(LANG_BULGARIAN, SUBLANG_BULGARIAN_BULGARIA), CODEPAGE_ANSI_CYRILLIC, "Bulgarian" },
	{ MAKELANGID(LANG_CATALAN, SUBLANG_CATALAN_CATALAN), CODEPAGE_ANSI_LATIN1, "Catalan" },
	{ MAKELANGID(LANG_CHINESE, SUBLANG_CHINESE_TRADITIONAL), CODEPAGE_OEM_TRADITIONAL_CHINESE, "Chinese (Taiwan)" },
	{ MAKELANGID(LANG_CHINESE, SUBLANG_CHINESE_SIMPLIFIED), CODEPAGE_OEM_SIMPLIFIED_CHINESE, "Chinese (PRC)" },
	{ MAKELANGID(LANG_CHINESE, SUBLANG_CHINESE_HONGKONG), CODEPAGE_OEM_TRADITIONAL_CHINESE, "Chinese (Hong Kong SAR, PRC)" },
	{ MAKELANGID(LANG_CHINESE, SUBLANG_CHINESE_SINGAPORE), CODEPAGE_OEM_SIMPLIFIED_CHINESE, "Chinese (Singapore)" },
	{ MAKELANGID(LANG_CHINESE, SUBLANG_CHINESE_MACAU), CODEPAGE_OEM_SIMPLIFIED_CHINESE, "Chinese (Macau SAR)" },
	{ MAKELANGID(LANG_CZECH, SUBLANG_CZECH_CZECH_REPUBLIC), CODEPAGE_ANSI_CENTRAL_EUROPE, "Czech" },
	{ MAKELANGID(LANG_DANISH, SUBLANG_DANISH_DENMARK), CODEPAGE_ANSI_LATIN1, "Danish" },
	{ MAKELANGID(LANG_GERMAN, SUBLANG_GERMAN), CODEPAGE_ANSI_LATIN1, "German (Standard)" },
	{ MAKELANGID(LANG_GERMAN, SUBLANG_GERMAN_SWISS), CODEPAGE_ANSI_LATIN1, "German (Switzerland)" },
	{ MAKELANGID(LANG_GERMAN, SUBLANG_GERMAN_AUSTRIAN), CODEPAGE_ANSI_LATIN1, "German (Austria)" },
	{ MAKELANGID(LANG_GERMAN, SUBLANG_GERMAN_LUXEMBOURG), CODEPAGE_ANSI_LATIN1, "German (Luxembourg)" },
	{ MAKELANGID(LANG_GERMAN, SUBLANG_GERMAN_LIECHTENSTEIN), CODEPAGE_ANSI_LATIN1, "German (Liechtenstein)" },
	{ MAKELANGID(LANG_GREEK, SUBLANG_GREEK_GREECE), CODEPAGE_ANSI_GREEK, "Greek" },
	{ MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_US), CODEPAGE_ANSI_LATIN1, "English (United States)" },
	{ MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_UK), CODEPAGE_ANSI_LATIN1, "English (United Kingdom)" },
	{ MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_AUS), CODEPAGE_ANSI_LATIN1, "English (Australia)" },
	{ MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_CAN), CODEPAGE_ANSI_LATIN1, "English (Canada)" },
	{ MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_NZ), CODEPAGE_ANSI_LATIN1, "English (New Zealand)" },
	{ MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_IRELAND), CODEPAGE_ANSI_LATIN1, "English (Ireland)" },
	{ MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_SOUTH_AFRICA), CODEPAGE_ANSI_LATIN1, "English (South Africa)" },
	{ MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_JAMAICA), CODEPAGE_ANSI_LATIN1, "English (Jamaica)" },
	{ MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_CARIBBEAN), CODEPAGE_ANSI_LATIN1, "English (Caribbean)" },
	{ MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_BELIZE), CODEPAGE_ANSI_LATIN1, "English (Belize)" },
	{ MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_TRINIDAD), CODEPAGE_ANSI_LATIN1, "English (Trinidad)" },
	{ MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_ZIMBABWE), CODEPAGE_ANSI_LATIN1, "English (Zimbabwe)" },
	{ MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_PHILIPPINES), CODEPAGE_ANSI_LATIN1, "English (Phillippines)" },
	{ MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_INDONESIA), CODEPAGE_ANSI_LATIN1, "English (Indonesia)" },
	{ MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_HONGKONG), CODEPAGE_ANSI_LATIN1, "English (Hongkong)" },
	{ MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_INDIA), CODEPAGE_ANSI_LATIN1, "English (India)" },
	{ MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_MALAYSIA), CODEPAGE_ANSI_LATIN1, "English (Malaysia)" },
	{ MAKELANGID(LANG_ENGLISH, SUBLANG_ENGLISH_SINGAPORE), CODEPAGE_ANSI_LATIN1, "English (Singapore)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH), CODEPAGE_ANSI_LATIN1, "Spanish (Spain, Traditional Sort)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_MEXICAN), CODEPAGE_ANSI_LATIN1, "Spanish (Mexico)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_MODERN), CODEPAGE_ANSI_LATIN1, "Spanish (Spain, Modern Sort)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_GUATEMALA), CODEPAGE_ANSI_LATIN1, "Spanish (Guatemala)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_COSTA_RICA), CODEPAGE_ANSI_LATIN1, "Spanish (Costa Rica)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_PANAMA), CODEPAGE_ANSI_LATIN1, "Spanish (Panama)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_DOMINICAN_REPUBLIC), CODEPAGE_ANSI_LATIN1, "Spanish (Dominican Republic)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_VENEZUELA), CODEPAGE_ANSI_LATIN1, "Spanish (Venezuela)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_COLOMBIA), CODEPAGE_ANSI_LATIN1, "Spanish (Colombia)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_PERU), CODEPAGE_ANSI_LATIN1, "Spanish (Peru)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_ARGENTINA), CODEPAGE_ANSI_LATIN1, "Spanish (Argentina)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_ECUADOR), CODEPAGE_ANSI_LATIN1, "Spanish (Ecuador)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_CHILE), CODEPAGE_ANSI_LATIN1, "Spanish (Chile)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_URUGUAY), CODEPAGE_ANSI_LATIN1, "Spanish (Uruguay)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_PARAGUAY), CODEPAGE_ANSI_LATIN1, "Spanish (Paraguay)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_BOLIVIA), CODEPAGE_ANSI_LATIN1, "Spanish (Bolivia)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_EL_SALVADOR), CODEPAGE_ANSI_LATIN1, "Spanish (El Salvador)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_HONDURAS), CODEPAGE_ANSI_LATIN1, "Spanish (Honduras)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_NICARAGUA), CODEPAGE_ANSI_LATIN1, "Spanish (Nicaragua)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_PUERTO_RICO), CODEPAGE_ANSI_LATIN1, "Spanish (Puerto Rico)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_US), CODEPAGE_ANSI_LATIN1, "Spanish (United States)" },
	{ MAKELANGID(LANG_SPANISH, SUBLANG_SPANISH_LATIN_AMERICA), CODEPAGE_ANSI_LATIN1, "Spanish (Latin America)" },
	{ MAKELANGID(LANG_FINNISH, SUBLANG_FINNISH_FINLAND), CODEPAGE_ANSI_LATIN1, "Finnish" },
	{ MAKELANGID(LANG_FRENCH, SUBLANG_FRENCH), CODEPAGE_ANSI_LATIN1, "French (France)" },
	{ MAKELANGID(LANG_FRENCH, SUBLANG_FRENCH_BELGIAN), CODEPAGE_ANSI_LATIN1, "French (Belgium)" },
	{ MAKELANGID(LANG_FRENCH, SUBLANG_FRENCH_CANADIAN), CODEPAGE_ANSI_LATIN1, "French (Canada)" },
	{ MAKELANGID(LANG_FRENCH, SUBLANG_FRENCH_SWISS), CODEPAGE_ANSI_LATIN1, "French (Switzerland)" },
	{ MAKELANGID(LANG_FRENCH, SUBLANG_FRENCH_LUXEMBOURG), CODEPAGE_ANSI_LATIN1, "French (Luxembourg)" },
	{ MAKELANGID(LANG_FRENCH, SUBLANG_FRENCH_MONACO), CODEPAGE_ANSI_LATIN1, "French (Monaco)" },
	{ MAKELANGID(LANG_HEBREW, SUBLANG_HEBREW_ISRAEL), CODEPAGE_ANSI_HEBREW, "Hebrew" },
	{ MAKELANGID(LANG_HUNGARIAN, SUBLANG_HUNGARIAN_HUNGARY), CODEPAGE_ANSI_CENTRAL_EUROPE, "Hungarian" },
	{ MAKELANGID(LANG_ICELANDIC, SUBLANG_ICELANDIC_ICELAND), CODEPAGE_ANSI_LATIN1, "Icelandic" },
	{ MAKELANGID(LANG_ITALIAN, SUBLANG_ITALIAN), CODEPAGE_ANSI_LATIN1, "Italian (Standard)" },
	{ MAKELANGID(LANG_ITALIAN, SUBLANG_ITALIAN_SWISS), CODEPAGE_ANSI_LATIN1, "Italian (Switzerland)" },
	{ MAKELANGID(LANG_JAPANESE, SUBLANG_JAPANESE_JAPAN), CODEPAGE_OEM_JAPANESE, "Japanese" },
	{ MAKELANGID(LANG_KOREAN, SUBLANG_KOREAN), CODEPAGE_OEM_KOREAN, "Korean" },
	{ MAKELANGID(LANG_KOREAN, SUBLANG_KOREAN_JOHAB), CODEPAGE_KOREAN_JOHAB, "Korean (Johab)" },
	{ MAKELANGID(LANG_DUTCH, SUBLANG_DUTCH), CODEPAGE_ANSI_LATIN1, "Dutch (Standard)" },
	{ MAKELANGID(LANG_DUTCH, SUBLANG_DUTCH_BELGIAN), CODEPAGE_ANSI_LATIN1, "Dutch (Belgium)" },
	{ MAKELANGID(LANG_NORWEGIAN, SUBLANG_NORWEGIAN_BOKMAL), CODEPAGE_ANSI_LATIN1, "Norwegian (Bokmal)" },
	{ MAKELANGID(LANG_NORWEGIAN, SUBLANG_NORWEGIAN_NYNORSK), CODEPAGE_ANSI_LATIN1, "Norwegian (Nynorsk)" },
	{ MAKELANGID(LANG_POLISH, SUBLANG_POLISH_POLAND), CODEPAGE_ANSI_CENTRAL_EUROPE, "Polish" },
	{ MAKELANGID(LANG_PORTUGUESE, SUBLANG_PORTUGUESE), CODEPAGE_ANSI_LATIN1, "Portuguese (Portugal)" },
	{ MAKELANGID(LANG_PORTUGUESE, SUBLANG_PORTUGUESE_BRAZILIAN), CODEPAGE_ANSI_LATIN1, "Portuguese (Brazil)" },
	{ MAKELANGID(LANG_ROMANSH, SUBLANG_ROMANSH_SWITZERLAND), CODEPAGE_ANSI_LATIN1, "Raeto-Romance" },
	{ MAKELANGID(LANG_ROMANIAN,  SUBLANG_ROMANIAN_ROMANIA), CODEPAGE_ANSI_CENTRAL_EUROPE, "Romanian" },
	{ MAKELANGID(LANG_ROMANIAN,  SUBLANG_ROMANIAN_MOLDAVIA), CODEPAGE_ANSI_LATIN1, "Romanian (Moldavia)" },
	{ MAKELANGID(LANG_RUSSIAN, SUBLANG_RUSSIAN_RUSSIA), CODEPAGE_ANSI_CYRILLIC, "Russian" },
	{ MAKELANGID(LANG_RUSSIAN, SUBLANG_RUSSIAN_MOLDAVIA), CODEPAGE_ANSI_CYRILLIC, "Russian (Moldavia)" },
	{ MAKELANGID(LANG_CROATIAN, SUBLANG_CROATIAN_CROATIA), CODEPAGE_ANSI_CENTRAL_EUROPE, "Croatian" },
	{ MAKELANGID(LANG_SERBIAN, SUBLANG_SERBIAN_LATIN), CODEPAGE_ANSI_CENTRAL_EUROPE, "Serbian (Latin)" },
	{ MAKELANGID(LANG_SERBIAN, SUBLANG_SERBIAN_CYRILLIC), CODEPAGE_ANSI_CYRILLIC, "Serbian (Cyrillic)" },
	{ MAKELANGID(LANG_SLOVAK, SUBLANG_SLOVAK_SLOVAKIA), CODEPAGE_ANSI_CENTRAL_EUROPE, "Slovak" },
	{ MAKELANGID(LANG_ALBANIAN, SUBLANG_ALBANIAN_ALBANIA), CODEPAGE_ANSI_CENTRAL_EUROPE, "Albanian" },
	{ MAKELANGID(LANG_SWEDISH, SUBLANG_SWEDISH), CODEPAGE_ANSI_LATIN1, "Swedish" },
	{ MAKELANGID(LANG_SWEDISH, SUBLANG_SWEDISH_FINLAND), CODEPAGE_ANSI_LATIN1, "Swedish (Finland)" },
	{ MAKELANGID(LANG_THAI, SUBLANG_THAI_THAILAND), CODEPAGE_ANSI_LATIN1, "Thai" },
	{ MAKELANGID(LANG_TURKISH, SUBLANG_TURKISH_TURKEY), CODEPAGE_ANSI_TURKISH, "Turkish" },
	{ MAKELANGID(LANG_URDU, SUBLANG_URDU_PAKISTAN), CODEPAGE_ANSI_ARABIC, "Urdu (Pakistan)" },
	{ MAKELANGID(LANG_URDU, SUBLANG_URDU_INDIA), CODEPAGE_ANSI_ARABIC, "Urdu (India)" },
	{ MAKELANGID(LANG_INDONESIAN, SUBLANG_INDONESIAN_INDONESIA), CODEPAGE_ANSI_LATIN1, "Indonesian" },
	{ MAKELANGID(LANG_UKRAINIAN, SUBLANG_UKRAINIAN_UKRAINE), CODEPAGE_ANSI_CYRILLIC, "Ukrainian" },
	{ MAKELANGID(LANG_BELARUSIAN, SUBLANG_BELARUSIAN_BELARUS), CODEPAGE_ANSI_CYRILLIC, "Belarusian" },
	{ MAKELANGID(LANG_SLOVENIAN, SUBLANG_SLOVENIAN_SLOVENIA), CODEPAGE_ANSI_CENTRAL_EUROPE, "Slovenian" },
	{ MAKELANGID(LANG_ESTONIAN, SUBLANG_ESTONIAN_ESTONIA), CODEPAGE_ANSI_BALTIC, "Estonian" },
	{ MAKELANGID(LANG_LATVIAN, SUBLANG_LATVIAN_LATVIA), CODEPAGE_ANSI_BALTIC, "Latvian" },
	{ MAKELANGID(LANG_LITHUANIAN, SUBLANG_LITHUANIAN), CODEPAGE_ANSI_BALTIC, "Lithuanian" },
	{ MAKELANGID(LANG_LITHUANIAN, SUBLANG_LITHUANIAN_CLASSIC), CODEPAGE_ANSI_BALTIC, "Lithuanian (Classic)" },
	{ MAKELANGID(LANG_TAJIK, SUBLANG_TAJIK_TAJIKISTAN), CODEPAGE_ANSI_CYRILLIC, "Tajik (Tajikistan)" },
	{ MAKELANGID(LANG_FARSI, SUBLANG_FARSI_IRAN), CODEPAGE_ANSI_ARABIC, "Farsi" },
	{ MAKELANGID(LANG_VIETNAMESE, SUBLANG_VIETNAMESE_VIETNAM), CODEPAGE_ANSI_LATIN1, "Vietnamese" },
	{ MAKELANGID(LANG_ARMENIAN, SUBLANG_ARMENIAN_ARMENIA), CODEPAGE_ANSI_LATIN1, "Armenian" },
	{ MAKELANGID(LANG_AZERI, SUBLANG_AZERI_LATIN), CODEPAGE_ANSI_TURKISH, "Azeri (Latin)" },
	{ MAKELANGID(LANG_AZERI, SUBLANG_AZERI_CYRILLIC), CODEPAGE_ANSI_CYRILLIC, "Azeri (Cyrillic)" },
	{ MAKELANGID(LANG_BASQUE, SUBLANG_BASQUE_BASQUE), CODEPAGE_ANSI_LATIN1, "Basque" },
	{ MAKELANGID(LANG_UPPER_SORBIAN, SUBLANG_UPPER_SORBIAN_GERMANY), CODEPAGE_ANSI_LATIN1, "Sorbian" },
	{ MAKELANGID(LANG_MACEDONIAN, SUBLANG_MACEDONIAN_MACEDONIA), CODEPAGE_ANSI_CYRILLIC, "FYRO Macedonian" },
	{ MAKELANGID(LANG_SUTU, SUBLANG_SUTU_SOUTH_AFRICA), CODEPAGE_ANSI_LATIN1, "Sutu" },
	{ MAKELANGID(LANG_TSONGA, SUBLANG_TSONGA_SOUTH_AFRICA), CODEPAGE_ANSI_LATIN1, "Tsonga" },
	{ MAKELANGID(LANG_TSWANA, SUBLANG_TSWANA_SOUTH_AFRICA), CODEPAGE_ANSI_LATIN1, "Setsuana (South Africa)" },
	{ MAKELANGID(LANG_TSWANA, SUBLANG_TSWANA_BOTSWANA), CODEPAGE_ANSI_LATIN1, "Setsuana (Botswana)" },
	{ MAKELANGID(LANG_VENDA, SUBLANG_VENDA_SOUTH_AFRICA), CODEPAGE_ANSI_LATIN1, "Venda" },
	{ MAKELANGID(LANG_XHOSA, SUBLANG_XHOSA_SOUTH_AFRICA), CODEPAGE_ANSI_LATIN1, "Xhosa" },
	{ MAKELANGID(LANG_ZULU, SUBLANG_ZULU_SOUTH_AFRICA), CODEPAGE_ANSI_LATIN1, "Zulu" },
	{ MAKELANGID(LANG_AFRIKAANS, SUBLANG_AFRIKAANS_SOUTH_AFRICA), CODEPAGE_ANSI_LATIN1, "Afrikaans" },
	{ MAKELANGID(LANG_GEORGIAN, SUBLANG_GEORGIAN_GEORGIA), CODEPAGE_ANSI_LATIN1, "Georgian" },
	{ MAKELANGID(LANG_FAEROESE, SUBLANG_FAEROESE_FAROE_ISLANDS), CODEPAGE_ANSI_LATIN1, "Faeroese" },
	{ MAKELANGID(LANG_HINDI, SUBLANG_HINDI_INDIA), CODEPAGE_ANSI_LATIN1, "Hindi" },
	{ MAKELANGID(LANG_MALTESE, SUBLANG_MALTESE_MALTA), CODEPAGE_ANSI_LATIN1, "Maltese" },
	{ MAKELANGID(LANG_SAMI, SUBLANG_SAMI_NORTHERN_NORWAY), CODEPAGE_ANSI_LATIN1, "Sami (Lapland)" },
	{ MAKELANGID(LANG_IRISH, SUBLANG_GAELIC), CODEPAGE_ANSI_LATIN1, "Gaelic (Scotland)" },
	{ MAKELANGID(LANG_IRISH, SUBLANG_IRISH_IRELAND), CODEPAGE_ANSI_LATIN1, "Gaelic (Ireland)" },
	{ MAKELANGID(LANG_YIDDISH, SUBLANG_YIDDISH_ISRAEL), CODEPAGE_ANSI_LATIN1, "Yiddish" },
	{ MAKELANGID(LANG_MALAY, SUBLANG_MALAY_MALAYSIA), CODEPAGE_ANSI_LATIN1, "Malay (Malaysia)" },
	{ MAKELANGID(LANG_MALAY, SUBLANG_MALAY_BRUNEI_DARUSSALAM), CODEPAGE_ANSI_LATIN1, "Malay (Brunei Darussalam)" },
	{ MAKELANGID(LANG_KAZAK, SUBLANG_KAZAK_KAZAKHSTAN), CODEPAGE_ANSI_CYRILLIC, "Kazakh (Kazakhstan)" },
	{ MAKELANGID(LANG_KYRGYZ, SUBLANG_KYRGYZ_KYRGYZSTAN), CODEPAGE_ANSI_CYRILLIC, "Kyrgyz" },
	{ MAKELANGID(LANG_SWAHILI, SUBLANG_SWAHILI_KENYA), CODEPAGE_ANSI_LATIN1, "Swahili" },
	{ MAKELANGID(LANG_TURKMEN, SUBLANG_TURKMEN_TURKMENISTAN), CODEPAGE_ANSI_CENTRAL_EUROPE, "Turkmen (Turkmenistan)" },
	{ MAKELANGID(LANG_UZBEK, SUBLANG_UZBEK_LATIN), CODEPAGE_ANSI_TURKISH, "Uzbek (Latin)" },
	{ MAKELANGID(LANG_UZBEK, SUBLANG_UZBEK_CYRILLIC), CODEPAGE_ANSI_CYRILLIC, "Uzbek (Cyrillic)" },
	{ MAKELANGID(LANG_TATAR, SUBLANG_TATAR_RUSSIA), CODEPAGE_ANSI_CYRILLIC, "Tatar (Tatarstan)" },
	{ MAKELANGID(LANG_BENGALI, SUBLANG_BENGALI_BANGLADESH), CODEPAGE_ANSI_LATIN1, "Bengali (Bangladesh)" },
	{ MAKELANGID(LANG_PUNJABI, SUBLANG_PUNJABI_INDIA), CODEPAGE_ANSI_LATIN1, "Punjabi" },
	{ MAKELANGID(LANG_GUJARATI, SUBLANG_GUJARATI_INDIA), CODEPAGE_ANSI_LATIN1, "Gujarati" },
	{ MAKELANGID(LANG_ORIYA, SUBLANG_ORIYA_INDIA), CODEPAGE_ANSI_LATIN1, "Oriya (India)" },
	{ MAKELANGID(LANG_TAMIL, SUBLANG_TAMIL_INDIA), CODEPAGE_ANSI_LATIN1, "Tamil (India)" },
	{ MAKELANGID(LANG_TAMIL, SUBLANG_TAMIL_SRI_LANKA), CODEPAGE_ANSI_LATIN1, "Tamil (Sri Lanka)" },
	{ MAKELANGID(LANG_TELUGU, SUBLANG_TELUGU_INDIA), CODEPAGE_ANSI_LATIN1, "Telugu" },
	{ MAKELANGID(LANG_KANNADA, SUBLANG_KANNADA_INDIA), CODEPAGE_ANSI_LATIN1, "Kannada" },
	{ MAKELANGID(LANG_MALAYALAM, SUBLANG_MALAYALAM_INDIA), CODEPAGE_ANSI_LATIN1, "Malayalam (India)" },
	{ MAKELANGID(LANG_ASSAMESE, SUBLANG_ASSAMESE_INDIA), CODEPAGE_ANSI_LATIN1, "Assamese (India)" },
	{ MAKELANGID(LANG_MARATHI, SUBLANG_MARATHI_INDIA), CODEPAGE_ANSI_LATIN1, "Marathi" },
	{ MAKELANGID(LANG_SANSKRIT, SUBLANG_SANSKRIT_INDIA), CODEPAGE_ANSI_LATIN1, "Sanskrit" },
	{ MAKELANGID(LANG_MONGOLIAN, SUBLANG_MONGOLIAN_CYRILLIC_MONGOLIA), CODEPAGE_ANSI_CYRILLIC, "Mongolian (Cyrillic)" },
	{ MAKELANGID(LANG_MONGOLIAN, SUBLANG_MONGOLIAN_PRC), CODEPAGE_ANSI_LATIN1, "Mongolian (Latin)" },
	{ MAKELANGID(LANG_TIBETAN, SUBLANG_TIBETAN_PRC), CODEPAGE_ANSI_LATIN1, "Tibetan (Tibet)" },
	{ MAKELANGID(LANG_TIBETAN, SUBLANG_TIBETAN_BHUTAN), CODEPAGE_ANSI_LATIN1, "Tibetan (Bhutan)" },
	{ MAKELANGID(LANG_WELSH, SUBLANG_WELSH_UNITED_KINGDOM), CODEPAGE_ISO_8859_14, "Welsh (United Kingdom)" },
	{ MAKELANGID(LANG_KHMER, SUBLANG_KHMER_CAMBODIA), CODEPAGE_OEM_KOREAN, "Khmer (Cambodia)" },
	{ MAKELANGID(LANG_LAO, SUBLANG_LAO_LAO), CODEPAGE_ANSI_LATIN1, "Lao (Lao PDR)" },
	{ MAKELANGID(LANG_BURMESE, SUBLANG_BURMESE_BURMA), CODEPAGE_OEM_THAI, "Burmese" },
	{ MAKELANGID(LANG_GALICIAN, SUBLANG_GALICIAN_GALICIAN), CODEPAGE_ANSI_LATIN1, "Galician" },
	{ MAKELANGID(LANG_KONKANI, SUBLANG_KONKANI_INDIA), CODEPAGE_ANSI_LATIN1, "Konkani" },
	{ MAKELANGID(LANG_MANIPURI, SUBLANG_MANIPURI_MANIPUR), CODEPAGE_ANSI_LATIN1, "Manipuri (Manipur)" },
	{ MAKELANGID(LANG_SINDHI, SUBLANG_SINDHI_INDIA), CODEPAGE_ANSI_LATIN1, "Sindhi (India)" },
	{ MAKELANGID(LANG_SINDHI, SUBLANG_SINDHI_PAKISTAN), CODEPAGE_ANSI_ARABIC, "Sindhi (Pakistan)" },
	{ MAKELANGID(LANG_SYRIAC, SUBLANG_SYRIAC_SYRIA), CODEPAGE_ANSI_LATIN1, "Syriac" },
	{ MAKELANGID(LANG_SINHALESE, SUBLANG_SINHALESE_SRI_LANKA), CODEPAGE_ANSI_LATIN1, "Sinhalese (Sri Lanka" },
	{ MAKELANGID(LANG_CHEROKEE, SUBLANG_CHEROKEE_CHEROKEE), CODEPAGE_ANSI_LATIN1, "Cherokee (United States)" },
	{ MAKELANGID(LANG_INUKTITUT, SUBLANG_INUKTITUT_CANADA), CODEPAGE_ANSI_LATIN1, "Inuktitut (Syllabics) (Canada)" },
	{ MAKELANGID(LANG_INUKTITUT, SUBLANG_INUKTITUT_CANADA_LATIN), CODEPAGE_ANSI_LATIN1, "Inuktitut (Latin)" },
	{ MAKELANGID(LANG_AMHARIC, SUBLANG_AMHARIC_ETHIOPIA), CODEPAGE_ANSI_LATIN1, "Amharic (Ethiopia)" },
	{ MAKELANGID(LANG_TAMAZIGHT, SUBLANG_TAMAZIGHT_MOROCCO), CODEPAGE_ANSI_ARABIC, "Tamazight (Morocco)" },
	{ MAKELANGID(LANG_TAMAZIGHT, SUBLANG_TAMAZIGHT_MOROCCO_TIFINAGH), CODEPAGE_ANSI_ARABIC, "Tamazight (Tifinagj)" },
	{ MAKELANGID(LANG_TAMAZIGHT, SUBLANG_TAMAZIGHT_ALGERIA_LATIN), CODEPAGE_ANSI_LATIN1, "Tamazight (Algeria)" },
	{ MAKELANGID(LANG_KASHMIRI, SUBLANG_KASHMIRI_PAKISTAN), CODEPAGE_ANSI_ARABIC, "Kashmiri (Pakistan)" },
	{ MAKELANGID(LANG_KASHMIRI, SUBLANG_KASHMIRI_SASIA), CODEPAGE_ANSI_LATIN1, "Kashmiri (South Asia)" },
	{ MAKELANGID(LANG_NEPALI, SUBLANG_NEPALI_NEPAL), CODEPAGE_ANSI_LATIN1, "Nepali (Nepal)" },
	{ MAKELANGID(LANG_NEPALI, SUBLANG_NEPALI_INDIA), CODEPAGE_ANSI_LATIN1, "Nepali (India)" },
	{ MAKELANGID(LANG_FRISIAN, SUBLANG_FRISIAN_NETHERLANDS), CODEPAGE_ANSI_LATIN1, "Frisian (Netherlands)" },
	{ MAKELANGID(LANG_PASHTO, SUBLANG_PASHTO_AFGHANISTAN), CODEPAGE_ANSI_LATIN1, "Pashto (Afghanistan)" },
	{ MAKELANGID(LANG_FILIPINO, SUBLANG_FILIPINO_PHILIPPINES), CODEPAGE_ANSI_LATIN1, "Tagalog (Philippines)" },
	{ MAKELANGID(LANG_DIVEHI, SUBLANG_DIVEHI_MALDIVES), CODEPAGE_ANSI_LATIN1, "Divehi" },
	{ MAKELANGID(LANG_GAELIC, SUBLANG_GAELIC), CODEPAGE_ANSI_LATIN1, "Gaelg (Manninn)" },

	{ MAKELANGID(LANG_NEUTRAL, SUBLANG_NEUTRAL), CODEPAGE_ANSI_LATIN1, "Language Neutral" },
	{ MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), CODEPAGE_ANSI_LATIN1, "User Default Language" },
	{ MAKELANGID(LANG_NEUTRAL, SUBLANG_SYS_DEFAULT), CODEPAGE_ANSI_LATIN1, "System Default Language" },
	{ MAKELANGID(LANG_INVARIANT, SUBLANG_NEUTRAL), CODEPAGE_ANSI_LATIN1, "Invariant Language" }
};

const char *get_lcid_string(LCID lcid)
{
	unsigned int i;
	
	lcid = LANGIDFROMLCID(lcid);
	for (i = 0; i < sizeof(lcid_strings) / sizeof(lcid_strings[0]); i++)
	{
		if (lcid_strings[i].lcid == lcid)
			return lcid_strings[i].lcid_string;
	}
	return NULL;
}

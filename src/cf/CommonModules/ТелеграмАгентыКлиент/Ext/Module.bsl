#Область ПрограмнныйИнтерфейс

#Область ИнициализацияКомпонентыTelegramNative

Функция ПроинициализироватьКомпоненту(ПопытатьсяУстановитьКомпоненту = Истина, ИмяПараметра = Неопределено) Экспорт
	
	Если ИмяПараметра = Неопределено Тогда
		ИмяПараметра = ТелеграмАгентыКлиентСервер.ИмяПараметраКомпоненты();
	КонецЕсли;
	
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		
		КодВозврата = ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаTelegram", "Telegram"); 
		Если Не КодВозврата Тогда
			
			Если Не ПопытатьсяУстановитьКомпоненту Тогда
				Возврат Ложь;
			КонецЕсли;
			
			УстановитьВнешнююКомпоненту("ОбщийМакет.КомпонентаTelegram");
			Возврат ПроинициализироватьКомпоненту(Ложь); // Рекурсивно.
			
		КонецЕсли;
		
		КомпонентаИнтеграции = Новый("AddIn.Telegram.TelegramNative");
		КомпонентаИнтеграции.УстановитьАсинхронныйРежим(Истина);

		ПараметрыПриложения.Вставить(ИмяПараметра, КомпонентаИнтеграции);
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область ОбработкаСобытийTelegramNative

Процедура ОбработатьСобытиеTelegramNative(Форма, Источник, Событие, СодержаниеОтветаJSON) Экспорт

	Если Не Событие = "Response" Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ СтрНайти(СодержаниеОтветаJSON, "@extra") Тогда
		Если Форма.ЖурналироватьВсеОтветыTelegramNative Тогда
			ТелеграмАгентыВызовСервера.СохранитьОтветTelegramNative(Форма.Агент, "", СодержаниеОтветаJSON);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	СодержаниеОтвета = ТелеграмАгентыКлиентСервер.ПреобразоватьВСоответствие(СодержаниеОтветаJSON);
	
	ИдентификаторЗапроса = СодержаниеОтвета.Получить("@extra");
	
	Если ИдентификаторЗапроса = Неопределено
		ИЛИ НЕ ЗначениеЗаполнено(ИдентификаторЗапроса) Тогда
		Возврат;
	КонецЕсли;
	
	ТелеграмАгентыВызовСервера.СохранитьОтветTelegramNative(Форма.Агент, ИдентификаторЗапроса, СодержаниеОтветаJSON);
	
	ОбработчикиОтвета = Форма.ОбработчикиОтветов.Получить(ИдентификаторЗапроса);
	
	Если ОбработчикиОтвета = Неопределено
		ИЛИ ТипЗнч(ОбработчикиОтвета) <> Тип("Массив")
		ИЛИ ОбработчикиОтвета.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
		
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ИдентификаторЗапроса", ИдентификаторЗапроса);
	ПараметрыОбработчика.Вставить("СодержаниеОтвета", СодержаниеОтвета);
	ПараметрыОбработчика.Вставить("СодержаниеОтветаJSON", СодержаниеОтветаJSON);
		
	Для Каждого ОбработчикОтвета Из ОбработчикиОтвета Цикл
		
		ВыполнитьОбработкуОповещения(ОбработчикОтвета, ПараметрыОбработчика);
		
	КонецЦикла;
	
	Форма.ОбработчикиОтветов.Удалить(ИдентификаторЗапроса);
	
КонецПроцедуры

#КонецОбласти

#Область ОтправкаЗапросов

Процедура ОтправитьЗапросАвторизации(СодержаниеЗапроса, Форма) Экспорт

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	
	ОбработчикиОтвета = Новый Массив;
	ОбработчикиОтвета.Добавить(Новый ОписаниеОповещения("ОбработатьОтветНаЗапросСостоянияАвторизации", ТелеграмАгентыКлиент, ДополнительныеПараметры));
	
	ОтправитьЗапрос(Форма.Агент, Форма.TelegramNative, СодержаниеЗапроса, Форма.ОбработчикиОтветов, ОбработчикиОтвета);
	
КонецПроцедуры

Процедура ОтправитьЗапросСостоянияАвторизации(Форма) Экспорт
	
	СодержаниеЗапроса = ТелеграмАгентыКлиентСервер.ЗапросСостоянияАвторизации();
	
	ОтправитьЗапросАвторизации(СодержаниеЗапроса, Форма);
		
КонецПроцедуры

Процедура ОтправитьЗапросУстановкиПараметровTDlib(Форма) Экспорт

	СодержаниеЗапроса = ТелеграмАгентыКлиентСервер.ЗапросУстановкаПараметровTDLib(Форма.АгентРасположениеTDDB, Форма.АгентИдентификаторПриложения, Форма.АгентХэшПриложения);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Форма", Форма);
	
	ОбработчикиОтвета = Новый Массив;
	ОбработчикиОтвета.Добавить(Новый ОписаниеОповещения("ОбработатьОтветНаЗапросСостоянияАвторизации", ТелеграмАгентыКлиент, ДополнительныеПараметры));
	
	ОтправитьЗапрос(Форма.Агент, Форма.TelegramNative, СодержаниеЗапроса, Форма.ОбработчикиОтветов, ОбработчикиОтвета);
	
КонецПроцедуры

Процедура ОтправитьЗапросУстановкиПараметровШифрования(Форма) Экспорт

	СодержаниеЗапроса = ТелеграмАгентыКлиентСервер.ЗапросПроверкаКлючаШифрования();
	
	ОтправитьЗапросАвторизации(СодержаниеЗапроса, Форма);
	
КонецПроцедуры

Процедура ОтправитьЗапросУстановкаТелефонногоНомера(Форма) Экспорт

	СодержаниеЗапроса = ТелеграмАгентыКлиентСервер.ЗапросУстановитьНомерТелефона(Форма.АгентНомерТелефона);
	
	ОтправитьЗапросАвторизации(СодержаниеЗапроса, Форма);
	
КонецПроцедуры

Процедура ОтправитьЗапросУстановкаКодаАвторизации(Форма) Экспорт

	СодержаниеЗапроса = ТелеграмАгентыКлиентСервер.ЗапросУстановитьКодАвторизации(Форма.АгентКодАвторизации);
	
	ОтправитьЗапросАвторизации(СодержаниеЗапроса, Форма);
	
КонецПроцедуры

Процедура ОтправитьЗапросСписокЧатов(Форма) Экспорт

	СодержаниеЗапроса = ТелеграмАгентыКлиентСервер.ЗапросСписокЧатов();
	
	ОтправитьЗапросАвторизации(СодержаниеЗапроса, Форма);
	
КонецПроцедуры

Функция ОтправитьЗапрос(Агент = Неопределено, TelegramNative, СодержаниеЗапроса, ОбработчикиОбратногоВызова, Обработчики = Неопределено, ЗНАЧ ИдентификаторЗапроса = Неопределено) Экспорт
	
	Если Агент = Неопределено Тогда
		Агент = ПредопределенноеЗначение("Справочник.ТелеграмАгенты.АгентПоУмолчанию");	
	КонецЕсли;
	
	Если TelegramNative = Неопределено Тогда
		TelegramNative = ПараметрыПриложения[ТелеграмАгентыКлиентСервер.ИмяПараметраКомпоненты()];
		
		Если TelegramNative = Неопределено Тогда
			ВызватьИсключение(НСтр("ru = 'Компонента Telegram.Native не установлена или не инициализирована. Запрос не отправлен.'"));
		КонецЕсли;
	КонецЕсли;
	
	Если ИдентификаторЗапроса = Неопределено Тогда
		ИдентификаторЗапроса = Строка(Новый УникальныйИдентификатор);
	КонецЕсли;

	СодержаниеЗапроса.Вставить("@extra", ИдентификаторЗапроса);
	
	Если Обработчики <> Неопределено Тогда
		ОбработчикиОбратногоВызова.Вставить(ИдентификаторЗапроса, Обработчики);
	КонецЕсли;
	
	СодержаниеЗапросаJSON = ТелеграмАгентыКлиентСервер.ПреобразоватьВJSON(СодержаниеЗапроса);
	
	Если СодержаниеЗапросаJSON = Неопределено Тогда
		Если Обработчики <> Неопределено Тогда
			ОбработчикиОбратногоВызова.Удалить(ИдентификаторЗапроса);
		КонецЕсли;
		ВызватьИсключение(НСтр("ru = 'Не удалось сформировать текст запроса к компоненте в формате JSON.'"));
	КонецЕсли;
	
	TelegramNative.Отправить(СодержаниеЗапросаJSON);
	
	ТелеграмАгентыВызовСервера.СохранитьЗапросTelegramNative(Агент, ИдентификаторЗапроса, СодержаниеЗапросаJSON, ТекущаяДата());
	
	Возврат СодержаниеЗапросаJSON;
	
КонецФункции

#КонецОбласти

#Область ОбработкаОтветов

Процедура ОбработатьОтветНаЗапросСостоянияАвторизации(ПараметрыОтвета, ДополнительныеПараметры) Экспорт

	Форма = ДополнительныеПараметры.Форма;
	
	СодержаниеОтвета = ПараметрыОтвета.СодержаниеОтвета;
		
	СостояниеАвторизации = СодержаниеОтвета.Получить("@type");
	
	Если СостояниеАвторизации = "authorizationStateWaitTdlibParameters" Тогда
		ОтправитьЗапросУстановкиПараметровTDlib(Форма);				
		
	ИначеЕсли СостояниеАвторизации = "authorizationStateWaitEncryptionKey" Тогда
		ОтправитьЗапросУстановкиПараметровШифрования(Форма);
		
	ИначеЕсли СостояниеАвторизации = "authorizationStateWaitPhoneNumber" Тогда
		ОтправитьЗапросУстановкаТелефонногоНомера(Форма);
		
	ИначеЕсли СостояниеАвторизации = "authorizationStateWaitCode" Тогда
		Форма.ОтобразитьСтраницуВводаКодаАвторизации();
		
	ИначеЕсли СостояниеАвторизации = "authorizationStateReady" Тогда
		ОтправитьЗапросСписокЧатов(Форма);
		Форма.ОтобразитьСтраницуОсновныхДействий();						
		
	ИначеЕсли СостояниеАвторизации = "ok" Тогда
		ОтправитьЗапросСостоянияАвторизации(Форма);
		
	ИначеЕсли СостояниеАвторизации = "error" Тогда
		ТекстПредупреждения = НСтр("ru = 'Ошибка во время обработки состояния авторизации компоненты TelegramNative. Обратитесь к администратору или повторите попытку.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Форма.ОтобразитьСтраницуВыбораАгента();
		
	КонецЕсли;
	
	ОбновляемыеПоля = Новый Структура;
	ОбновляемыеПоля.Вставить("ОтветОбработан", Истина);
	Если СостояниеАвторизации = "error" Тогда
		ОбновляемыеПоля.Вставить("ЕстьОшибка", Истина);
	КонецЕсли;
	
	ТелеграмАгентыВызовСервера.ОбновитьЗаписьЗапросаTelegramNative(Форма.Агент, ПараметрыОтвета.ИдентификаторЗапроса, ОбновляемыеПоля);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаВнешнихЗапросов

Процедура ОбработатьВнешниеЗапросы(Форма) Экспорт
	
	ДанныеЗапросов = ТелеграмАгентыВызовСервера.ДанныеВнешнихЗапросов(Форма.Агент, , Истина, Форма.КоличествоОбрабатываемыхЗапросов, Истина);
	
	Если ДанныеЗапросов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ДанныеЗапроса Из ДанныеЗапросов Цикл
		
		ОбработатьВнешнийЗапрос(ДанныеЗапроса, Форма);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьВнешнийЗапрос(ДанныеЗапроса, Форма) Экспорт

	ПредОбработкаОтправляемыхДанных(ДанныеЗапроса, Форма.УникальныйИдентификатор);
		
	Если ДанныеЗапроса.СодержаниеЗапроса = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ДанныеЗапроса", ДанныеЗапроса);
	ДополнительныеПараметры.Вставить("УникальныйИдентификаторФормы", Форма.УникальныйИдентификатор);
	Обработчики = Новый Массив;
	Обработчики.Добавить(Новый ОписаниеОповещения("ОбработатьОтветПоВнешнемуЗапросу", ТелеграмАгентыКлиент, ДополнительныеПараметры));
	
	РезультатЗапроса = ТелеграмАгентыКлиент.ОтправитьЗапрос(Форма.Агент, Форма.TelegramNative, ДанныеЗапроса.СодержаниеЗапроса, Форма.ОбработчикиОтветов, Обработчики, ДанныеЗапроса.Идентификатор);
	
	Если РезультатЗапроса <> Неопределено Тогда
		ОбновляемыеПоля = Новый Структура;
		ОбновляемыеПоля.Вставить("Статус", ТелеграмАгентыКлиентСервер.СтатусОтправлен());
		ОбновляемыеПоля.Вставить("Обработан", Истина);
		ТелеграмАгентыВызовСервера.ОбновитьЗаписьВнешнегоЗапросаАгенту(Форма.Агент, ДанныеЗапроса.Идентификатор, ОбновляемыеПоля);	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработатьОтветПоВнешнемуЗапросу(ПараметрыОтвета, ДополнительныеПараметры) Экспорт
		
	ДанныеЗапроса = ДополнительныеПараметры.ДанныеЗапроса;
	
	УникальныйИдентификаторФормы = ДополнительныеПараметры.УникальныйИдентификаторФормы;
	
	ПостОбработкаОтправляемыхДанных(ДанныеЗапроса, УникальныйИдентификаторФормы);

	ОбновляемыеПоля = Новый Структура;
	ОбновляемыеПоля.Вставить("ОтветОбработан", Истина);
	
	ТелеграмАгентыВызовСервера.ОбновитьЗаписьЗапросаTelegramNative(ДанныеЗапроса.Агент, ПараметрыОтвета.ИдентификаторЗапроса, ОбновляемыеПоля);

	
КонецПроцедуры

#КонецОбласти

#область НепереработанныеВерсии

Процедура ПредОбработкаОтправляемыхДанных(ДанныеЗапроса, УникальныйИдентификаторФормы) Экспорт
	
	Если ДанныеЗапроса.Команда = "sendMessage" Тогда
		ПредОбработкаОтправляемыхДанных_sendMessage(ДанныеЗапроса, УникальныйИдентификаторФормы);
	КонецЕсли;
	
КонецПроцедуры 

Процедура ПредОбработкаОтправляемыхДанных_sendMessage(ДанныеЗапроса, УникальныйИдентификаторФормы)
	
	Если ДанныеЗапроса.СодержаниеЗапроса.Получить("input_message_content").Получить("@type") <> "inputMessageDocument" Тогда
		Возврат;
	КонецЕсли;
	
	СодержаниеЗапроса = ДанныеЗапроса.СодержаниеЗапроса;
	
	АдресДвоичныхДанныхВоВременномХранилище = СодержаниеЗапроса.Получить("input_message_content").Получить("document").Получить("content_address");
	ИмяФайла = СодержаниеЗапроса.Получить("input_message_content").Получить("document").Получить("path");
	Если АдресДвоичныхДанныхВоВременномХранилище = Неопределено
		ИЛИ ИмяФайла = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(АдресДвоичныхДанныхВоВременномХранилище);
	Если ТипЗнч(ДвоичныеДанныеФайла) <> Тип("ДвоичныеДанные") Тогда
		Возврат;
	КонецЕсли;
	
	КаталогВременныхФайлов = ПолучитьИмяВременногоФайла("");
	ПолноеИмяФайла = КаталогВременныхФайлов + "\" + ИмяФайла;
	Попытка
		СоздатьКаталог(КаталогВременныхФайлов);
		ДвоичныеДанныеФайла.Записать(ПолноеИмяФайла);
	Исключение
		Возврат;
	КонецПопытки;

	УдалитьИзВременногоХранилища(АдресДвоичныхДанныхВоВременномХранилище);
	СодержаниеЗапроса.Получить("input_message_content").Получить("document").Удалить("content_address");
	СодержаниеЗапроса.Получить("input_message_content").Получить("document").Вставить("path", ПолноеИмяФайла);
	ДанныеЗапроса.Вставить("КаталогВременныхФайлов", КаталогВременныхФайлов);
	
КонецПроцедуры

Процедура ПостОбработкаОтправляемыхДанных(ДанныеЗапроса, УникальныйИдентификаторФормы) Экспорт
	
	Если ДанныеЗапроса.Команда = "sendMessage" Тогда
		ПостОбработкаОтправляемыхДанных_sendMessage(ДанныеЗапроса, УникальныйИдентификаторФормы);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПостОбработкаОтправляемыхДанных_sendMessage(ДанныеЗапроса, УникальныйИдентификаторФормы);

	Если ДанныеЗапроса.СодержаниеЗапроса.Получить("input_message_content").Получить("@type") <> "inputMessageDocument" 
		ИЛИ Не ДанныеЗапроса.Свойство("КаталогВременныхФайлов") Тогда
		Возврат;
	КонецЕсли;
	
	КаталогВременныхФайлов = ДанныеЗапроса.КаталогВременныхФайлов;
	
	Если Не ЗначениеЗаполнено(КаталогВременныхФайлов) Тогда
		Возврат;
	КонецЕсли;
	
	Попытка
		//УдалитьФайлы(КаталогВременныхФайлов);
	Исключение
		
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти


#КонецОбласти

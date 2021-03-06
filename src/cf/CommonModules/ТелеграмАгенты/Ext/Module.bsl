#Область ПрограммныйИнтерфейс

#Область ОбработкаВходящихЗапросов

Функция ДанныеВнешнихЗапросов(ЗНАЧ Агент = Неопределено, ЗНАЧ ИдентификаторыЗапросов = Неопределено, ТолькоНеОбработанные = Ложь, ЗНАЧ КоличествоПервых = Неопределено, ВыполнятьДополнительнуюОбработку = Ложь, УникальныйИдентификаторФормы = Неопределено) Экспорт
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ЗапросыИОтветыТелеграмАгентов.Период КАК Период,
		|	ЗапросыИОтветыТелеграмАгентов.Агент КАК Агент,
		|	ЗапросыИОтветыТелеграмАгентов.Идентификатор КАК Идентификатор,
		|	ЗапросыИОтветыТелеграмАгентов.ЕстьОшибка КАК ЕстьОшибка,
		|	ЗапросыИОтветыТелеграмАгентов.Обработан КАК Обработан,
		|	ЗапросыИОтветыТелеграмАгентов.Статус КАК Статус,
		|	ЗапросыИОтветыТелеграмАгентов.ОтветПолучен КАК ОтветПолучен,
		|	ЗапросыИОтветыТелеграмАгентов.СодержаниеЗапросаJSON КАК СодержаниеЗапросаJSON,
		|	ЗапросыИОтветыТелеграмАгентов.Команда КАК Команда,
		|	ЗапросыИОтветыТелеграмАгентов.ДатаОбработки КАК ДатаОбработки,
		|	ЗапросыИОтветыТелеграмАгентов.ОписаниеОшибки КАК ОписаниеОшибки,
		|	ЗапросыИОтветыТелеграмАгентов.СодержаниеОтветаJSON КАК СодержаниеОтветаJSON,
		|	ЗапросыИОтветыТелеграмАгентов.ДатаПолученияОтвета КАК ДатаПолученияОтвета
		|ИЗ
		|	РегистрСведений.ЗапросыИОтветыТелеграмАгентов КАК ЗапросыИОтветыТелеграмАгентов
		|ГДЕ
		|	&УсловиеОтбораПоАгенту
		|	И &УсловиеОтбораПоИдентификаторам
		|	И &УсловиеОтбораТолькоОбработанные";
	
	Если Агент = Неопределено Тогда
		Агент = Справочники.ТелеграмАгенты.АгентПоУмолчанию;
	КонецЕсли;
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеОтбораПоАгенту", "ЗапросыИОтветыТелеграмАгентов.Агент = &Агент");
	
	Если ИдентификаторыЗапросов = Неопределено Тогда
	    ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеОтбораПоИдентификаторам", "Истина");
	ИначеЕсли ТипЗнч(ИдентификаторыЗапросов) = Тип("Строка") Тогда
		ИдентификаторЗапроса = ИдентификаторыЗапросов;
		ИдентификаторыЗапросов = Новый Массив;
		ИдентификаторыЗапросов.Добавить(ИдентификаторЗапроса);
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеОтбораПоИдентификаторам", "ЗапросыИОтветыТелеграмАгентов.Идентификатор В(&ИдентификаторыЗапросов)");
	ИначеЕсли ТипЗнч(ИдентификаторыЗапросов) = Тип("Массив") Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеОтбораПоИдентификаторам", "ЗапросыИОтветыТелеграмАгентов.Идентификатор В(&ИдентификаторыЗапросов)");
	КонецЕсли;
	
	Если ТолькоНеОбработанные Тогда
	    ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеОтбораТолькоОбработанные", "НЕ ЗапросыИОтветыТелеграмАгентов.Обработан");
	Иначе
	    ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеОтбораТолькоОбработанные", "Истина");
	КонецЕсли;
	
	Если КоличествоПервых <> Неопределено
		И ТипЗНЧ(КоличествоПервых) = Тип("Число") Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВЫБРАТЬ", СтрШаблон("ВЫБРАТЬ ПЕРВЫЕ %1", КоличествоПервых));				
	КонецЕсли;
	
	Запрос = Новый Запрос;
    Запрос.УстановитьПараметр("Агент", Агент);
    Запрос.УстановитьПараметр("ИдентификаторыЗапросов", ИдентификаторыЗапросов);
	
	Запрос.Текст = ТекстЗапроса;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ДанныеЗапросов = РезультатЗапроса.Выгрузить();
	ДанныеЗапросов.Колонки.Добавить("СодержаниеЗапроса");
	
	Если ВыполнятьДополнительнуюОбработку Тогда
		Для Каждого ДанныеЗапроса Из ДанныеЗапросов Цикл
			
			Попытка
				СодержаниеЗапроса = ТелеграмАгентыКлиентСервер.ПреобразоватьВСоответствие(ДанныеЗапроса.СодержаниеЗапросаJSON);
			Исключение
				СодержаниеЗапроса = Неопределено;	
			КонецПопытки;
			
			ВыполнитьПредобработку(СодержаниеЗапроса, УникальныйИдентификаторФормы);
			
			ДанныеЗапроса.СодержаниеЗапроса = СодержаниеЗапроса;
			
		КонецЦикла;
	КонецЕсли;
	
	ДанныеЗапросов = ОбщегоНазначения.ТаблицаЗначенийВМассив(ДанныеЗапросов);
	
	Возврат ДанныеЗапросов;	
	
КонецФункции

Процедура ВыполнитьПредобработку(СодержаниеЗапроса, УникальныйИдентификаторФормы = Неопределено) Экспорт
	
	Если ТипЗнч(СодержаниеЗапроса) <> Тип("Соответствие") Тогда
		Возврат;
	КонецЕсли;
	
	Команда = СодержаниеЗапроса.Получить("@type"); 
 
	Если Команда = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Команда = "sendMessage" Тогда
		ВыполнитьПредобработку_sendMessage(СодержаниеЗапроса, УникальныйИдентификаторФормы);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьПредобработку_sendMessage(СодержаниеЗапроса, УникальныйИдентификаторФормы)
	
	Сообщение = СодержаниеЗапроса.Получить("input_message_content");
	
	Если Сообщение = Неопределено
		ИЛИ ТипЗнч(Сообщение) <> Тип("Соответствие") 
		ИЛИ Сообщение.Получить("@type") <> "inputMessageDocument" Тогда
		Возврат;
	КонецЕсли;
		
	Файл = Сообщение.Получить("document");
	
	Если Файл = Неопределено
		ИЛИ ТипЗнч(Файл) <> Тип("Соответствие") 
		ИЛИ Файл.Получить("@type") <> "inputFileLocal" Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеФайлаBase64 = РаскодироватьСтроку(Файл.Получить("contentBase64"), СпособКодированияСтроки.КодировкаURL);
	Файл.Удалить("contentBase64");
	
	ДанныеФайлаДвоичные = Base64Значение(ДанныеФайлаBase64);
	
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДанныеФайлаДвоичные, УникальныйИдентификаторФормы);
		
	Файл.Вставить("content_address", АдресВоВременномХранилище);
	
КонецПроцедуры

#КонецОбласти

#Область ЖурналированиеЗапросовОтветовTelegramNative

Процедура СохранитьЗапросTelegramNative(ЗНАЧ Агент = Неопределено, ЗНАЧ ИдентификаторЗапроса, ЗНАЧ СодержаниеЗапросаJSON, ЗНАЧ ДатаОтправкиЗапроса) Экспорт
	
	Если Агент = Неопределено Тогда
		Агент = Справочники.ТелеграмАгенты.АгентПоУмолчанию;
	КонецЕсли;

	Если ДатаОтправкиЗапроса = Неопределено Тогда
		ДатаОтправкиЗапроса = ТекущаяДата();
	КонецЕсли;
	
	Запись = РегистрыСведений.ЗапросыTelegramNative.СоздатьМенеджерЗаписи();
	Запись.Период = ДатаОтправкиЗапроса;
	Запись.Активность = Истина;
	Запись.Агент = Агент;
	Запись.Идентификатор = ИдентификаторЗапроса;
	Запись.Содержание = СодержаниеЗапросаJSON;
	
	Попытка
		Запись.Записать(Истина);
	Исключение
		ВызватьИсключение НСтр("ru = 'Не удалось сохранить содержание запроса Telegram Native.'");
	КонецПопытки;
	
КонецПроцедуры

Процедура СохранитьОтветTelegramNative(ЗНАЧ Агент = Неопределено, ЗНАЧ ИдентификаторЗапроса = Неопределено, ЗНАЧ СодержаниеОтветаJSON, ЗНАЧ ДатаПолученияОтвета = Неопределено) Экспорт
	
	Если Агент = Неопределено Тогда
		Агент = Справочники.ТелеграмАгенты.АгентПоУмолчанию;
	КонецЕсли;
	
	Если ДатаПолученияОтвета = Неопределено Тогда
		ДатаПолученияОтвета = ТекущаяДата();		
	КонецЕсли;
	
	Если ИдентификаторЗапроса = Неопределено Тогда
		ИдентификаторЗапроса = "";
	КонецЕсли;
	
	Запись = РегистрыСведений.ОтветыTelegramNative.СоздатьМенеджерЗаписи();
	Запись.Период = ДатаПолученияОтвета;
	Запись.Активность = Истина;
	Запись.Агент = Агент;
	Запись.Идентификатор = ИдентификаторЗапроса;
	Запись.ОтветОбработан = Ложь;
	Запись.Содержание = СодержаниеОтветаJSON;
	Запись.ДатаПолученияОтвета = ДатаПолученияОтвета;
	
	Попытка
		Запись.Записать(Истина);
	Исключение
	КонецПопытки;
	
	Если ЗначениеЗаполнено(ИдентификаторЗапроса) Тогда
		ОбновляемыеПоля = Новый Структура;
		ОбновляемыеПоля.Вставить("ОтветПолучен", Истина); 
		ОбновляемыеПоля.Вставить("ДатаПолученияОтвета", ДатаПолученияОтвета);
		ОбновитьЗаписьЗапросаTelegramNative(Агент, ИдентификаторЗапроса, ОбновляемыеПоля);
		
		ОбновляемыеПоля.Вставить("Статус", ТелеграмАгентыКлиентСервер.СтатусПолученОтвет());
		ОбновляемыеПоля.Вставить("СодержаниеОтветаJSON", СодержаниеОтветаJSON);
		ОбновитьЗаписьВнешнегоЗапросаАгенту(Агент, ИдентификаторЗапроса, ОбновляемыеПоля);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьЗаписьЗапросаTelegramNative(ЗНАЧ Агент = Неопределено, ЗНАЧ ИдентификаторЗапроса, ОбновляемыеПоля) Экспорт
	
	Если ОбновляемыеПоля = Неопределено
		ИЛИ ТипЗнч(ОбновляемыеПоля) <> Тип("Структура")
		ИЛИ ОбновляемыеПоля.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Если Агент = Неопределено Тогда
		Агент = Справочники.ТелеграмАгенты.АгентПоУмолчанию;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ЗапросыTelegramNative.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Агент.Установить(Агент);
	НаборЗаписей.Отбор.Идентификатор.Установить(ИдентификаторЗапроса);
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЕстьИзменения = Ложь;
	Для Каждого Запись Из НаборЗаписей Цикл
		
		Для Каждого ОбновляемоеПоле Из ОбновляемыеПоля Цикл
			
			Если Запись[ОбновляемоеПоле.Ключ] = ОбновляемоеПоле.Значение Тогда
				Продолжить;
			КонецЕсли;
			
			Запись[ОбновляемоеПоле.Ключ] = ОбновляемоеПоле.Значение;
			ЕстьИзменения = Истина;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Если Не ЕстьИзменения Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ЖурналированиеВнешнихЗапросовТелеграмАгентам

Функция СохранитьВнешнийЗапросАгенту(ЗНАЧ Агент = Неопределено, ЗНАЧ СодержаниеЗапросаJSON, ЗНАЧ Команда, ЗНАЧ ДатаЗапроса = Неопределено) Экспорт

	Если Агент = Неопределено Тогда
		Агент = Справочники.ТелеграмАгенты.АгентПоУмолчанию;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДатаЗапроса) Тогда
		ДатаЗапроса = ТекущаяДата();
	КонецЕсли;
	
	Идентификатор = Строка(Новый УникальныйИдентификатор);
	
	ДанныеЗаписи = Новый Структура;
	ДанныеЗаписи.Вставить("Период", ДатаЗапроса);
	ДанныеЗаписи.Вставить("Агент", Агент);
	ДанныеЗаписи.Вставить("Идентификатор", Идентификатор);
	ДанныеЗаписи.Вставить("Команда", Команда); 
	ДанныеЗаписи.Вставить("СодержаниеЗапросаJSON", СодержаниеЗапросаJSON);
	ДанныеЗаписи.Вставить("ЕстьОшибка", Ложь);
	ДанныеЗаписи.Вставить("Обработан", Ложь);
	ДанныеЗаписи.Вставить("Статус", ТелеграмАгентыКлиентСервер.СтатусНовыйЗапрос());
	
	Запись = РегистрыСведений.ЗапросыИОтветыТелеграмАгентов.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Запись, ДанныеЗаписи);
	
	Попытка
		Запись.Записать();
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
	Возврат Идентификатор;
	
КонецФункции

Процедура ОбновитьЗаписьВнешнегоЗапросаАгенту(ЗНАЧ Агент = Неопределено, ЗНАЧ ИдентификаторЗапроса, ОбновляемыеПоля) Экспорт
	
	Если ОбновляемыеПоля = Неопределено
		ИЛИ ТипЗнч(ОбновляемыеПоля) <> Тип("Структура")
		ИЛИ ОбновляемыеПоля.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	Если Агент = Неопределено Тогда
		Агент = Справочники.ТелеграмАгенты.АгентПоУмолчанию;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.ЗапросыИОтветыТелеграмАгентов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Агент.Установить(Агент);
	НаборЗаписей.Отбор.Идентификатор.Установить(ИдентификаторЗапроса);
	НаборЗаписей.Прочитать();
	
	Если НаборЗаписей.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ЕстьИзменения = Ложь;
	Для Каждого Запись Из НаборЗаписей Цикл
		
		Для Каждого ОбновляемоеПоле Из ОбновляемыеПоля Цикл
			
			Если Запись[ОбновляемоеПоле.Ключ] = ОбновляемоеПоле.Значение Тогда
				Продолжить;
			КонецЕсли;
			
			Запись[ОбновляемоеПоле.Ключ] = ОбновляемоеПоле.Значение;
			ЕстьИзменения = Истина;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Если Не ЕстьИзменения Тогда
		Возврат;
	КонецЕсли;
	
	НаборЗаписей.Записать(Истина);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
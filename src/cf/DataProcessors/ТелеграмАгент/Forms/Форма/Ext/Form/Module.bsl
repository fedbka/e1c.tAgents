﻿&НаКлиенте
Перем TelegramNative Экспорт;

&НаКлиенте
Перем ОбработчикиОтветов Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ЭтаФорма.Заголовок = "Телеграм-агент";
	
	ЭтаФорма.ОбрабатыватьВнешниеЗапросы = Ложь;
	ЭтаФорма.ИнтервалОбработки = 5;
	ЭтаФорма.КоличествоОбрабатываемыхЗапросов = 10;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбработчикиОтветов = Новый Соответствие;
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ВыборТелеграмАгента;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)

	Если Источник = "TelegramNative" Тогда
		ТелеграмАгентыКлиент.ОбработатьСобытиеTelegramNative(ЭтаФорма, Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура АгентПриИзменении(Элемент)
	
	АгентПриИзмененииНаСервере();
	
	Если Не ЗначениеЗаполнено(ЭтаФорма.АгентРасположениеTDDB) Тогда
		ЭтаФорма.АгентРасположениеTDDB = КаталогВременныхФайлов() + "TDDB_" + ЭтаФорма.АгентКод;
	КонецЕсли;
	
	ЭтаФорма.Заголовок = СтрШаблон(НСтр("ru = 'Телеграм агент ""%1"" (%2)'"), ЭтаФорма.АгентНаименование, Этаформа.АгентНомерТелефона);
	
КонецПроцедуры

&НаСервере
Процедура АгентПриИзмененииНаСервере()

	Если НЕ ЗначениеЗаполнено(ЭтаФорма.Агент) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполняемыеРеквизитыСтрокой = "Код,Наименование,НомерТелефона,РасположениеTDDB,ИдентификаторПриложения,ХэшПриложения";
	ЗаполняемыеРеквизиты = СтрРазделить(ЗаполняемыеРеквизитыСтрокой, ",", Ложь);
	
	Для Каждого Реквизит Из ЗаполняемыеРеквизиты Цикл
		ЭтаФорма["Агент" + Реквизит] = "";
	КонецЦикла;
	
	ДанныеАгента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЭтаФорма.Агент, ЗаполняемыеРеквизитыСтрокой);
	
	Для Каждого Реквизит Из ЗаполняемыеРеквизиты Цикл
		ЭтаФорма["Агент" + Реквизит] = ДанныеАгента[Реквизит];
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВнешнихЗапросовВыполняетсяПриИзменении(Элемент)
	
	ПодключитьОтключитьОбработкуВнешнихЗапросов();

КонецПроцедуры

&НаКлиенте
Процедура ПериодичностьОбработкиПриИзменении(Элемент)

	ПодключитьОтключитьОбработкуВнешнихЗапросов();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИнициализироватьАгента(Команда)
	
	Если Не ОбязательныеДанныеАгентаЗаполнены() Тогда
		Возврат;
	КонецЕсли;
	
	ИнициализацияКомпонентыTelegramNative();
	
КонецПроцедуры

&НаКлиенте
Процедура ЖурналироватьВсеОтветыTelegramNative(Команда)
	
	ЭтаФорма.ЖурналироватьВсеОтветыTelegramNative = Не ЭтаФорма.ЖурналироватьВсеОтветыTelegramNative;
	
	Элементы.ФормаЖурналироватьВсеОтветыTelegramNative.Пометка = ЭтаФорма.ЖурналироватьВсеОтветыTelegramNative;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьКодАвторизации(Команда)
	
	ТелеграмАгентыКлиент.ОтправитьЗапросУстановкаКодаАвторизации(ЭтаФорма);
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ИнициализацияКомпоненты;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьВыполнениеОбработкиВнешнихЗапросов(Команда)
	
	ЭтаФорма.ОбработкаВнешнихЗапросовВыполняется = Не ЭтаФорма.ОбработкаВнешнихЗапросовВыполняется;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработатьВнешниеЗапросы() 

	ТелеграмАгентыКлиент.ОбработатьВнешниеЗапросы(ЭтаФорма);
	
	Элементы.ЗапросыТелеграмАгентам.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьОтключитьОбработкуВнешнихЗапросов()
	
	ОтключитьОбработчикОжидания("ОбработатьВнешниеЗапросы");	
	
	Если ЭтаФорма.ОбрабатыватьВнешниеЗапросы Тогда
		ИнтервалСрабатыванияОбработчика = Мин(5, ЭтаФорма.ИнтервалОбработки);
		ПодключитьОбработчикОжидания("ОбработатьВнешниеЗапросы", ИнтервалСрабатыванияОбработчика);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ОбязательныеДанныеАгентаЗаполнены()
	
	ОбязательныеРеквизиты = ТелеграмАгентыКлиентСервер.ОбязательныеРеквизитыАгента();
	
	Для Каждого Реквизит Из ОбязательныеРеквизиты Цикл
		
		Если ЗначениеЗаполнено(ЭтаФорма["Агент" + Реквизит]) Тогда
			Продолжить;
		КонецЕсли;
		
		ТекстПредупреждения = СтрШаблон(НСтр("ru = 'Не указан ""%1"" агента. Инициализация невозможна.'"), Реквизит);
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат Ложь;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ИнициализацияКомпонентыTelegramNative()
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ИнициализацияКомпоненты;
	
	ИмяПараметраКомпоненты = ТелеграмАгентыКлиентСервер.ИмяПараметраКомпоненты();	
	
	Если Не ТелеграмАгентыКлиент.ПроинициализироватьКомпоненту(, ИмяПараметраКомпоненты) Тогда
		ТекстПредупреждения = НСтр("ru = 'Не удалось инициализировать компоненту TelegramNative. Работа агента невозможна.'");
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ВыборТелеграмАгента;
		TelegramNative = Неопределено;
		Возврат;
	КонецЕсли;
	
	TelegramNative = ПараметрыПриложения[ИмяПараметраКомпоненты];
	
	ТелеграмАгентыКлиент.ОтправитьЗапросСостоянияАвторизации(ЭтаФорма);	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьСтраницуВводаКодаАвторизации() Экспорт
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ВводКодаАвторизации;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьСтраницуОсновныхДействий() Экспорт
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ОбработкаВнешнихЗапросов;	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьСтраницуВыбораАгента() Экспорт
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ВыборТелеграмАгента;	
	
КонецПроцедуры

#КонецОбласти
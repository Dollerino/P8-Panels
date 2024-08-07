create or replace package PKG_P8PANELS_MECHREC as

  /* Проверка соответствия подразделения документа подразделению пользователя */
  function UTL_SUBDIV_CHECK
  (
    NCOMPANY                in number,  -- Рег. номер организации
    NSUBDIV                 in number,  -- Рег. номер подразделения
    SUSER                   in varchar2 -- Имя пользователя    
  ) return                  number;     -- Подразделение подходит (0 - нет, 1 - да)
  
  /* Проверка соответствия подразделения документа подразделению пользователя (по иерархии) */
  function UTL_SUBDIV_HIER_CHECK
  (
    NCOMPANY                in number,        -- Рег. номер организации
    NSUBDIV                 in number,        -- Рег. номер подразделения
    SUSER                   in varchar2,      -- Имя пользователя
    NSTART_SUBDIV           in number := null -- Рег. номер родительского подразделения
  ) return                  number;           -- Подразделение подходит (0 - нет, 1 - да)
  
  /* Проверка наличия станка "В эксплуатации" в иерархии цеха */
  function UTL_INS_DEP_HIER_EQ_CHECK
  (
    NCOMPANY                in number,  -- Рег. номер организации
    NINS_DEPARTMENT         in number,  -- Рег. номер подразделения (цеха)
    DDATE_TO                in date     -- Дата по
  ) return                  number;     -- Результат (0 - станка нет, 1 - станок есть)
  
  /* Считывание количества рабочих часов с учетом перерыва */
  function UTL_WORK_TIME_GET
  (
    NTBOPERMODESP           in number   -- Рег. номер смены
  ) return                  number;     -- Количество рабочих часов
  
  /* Получение таблицы ПиП на основании маршрутного листа, связанных со спецификацией плана */
  procedure INCOMEFROMDEPS_DG_GET
  (
    NFCPRODPLANSP           in number,  -- Рег. номер связанной спецификации плана
    NTYPE                   in number,  -- Тип спецификации плана (2 - Не включать "Состояние", 3 - включать)
    NPAGE_NUMBER            in number,  -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,  -- Количество записей на странице (0 - все)
    CORDERS                 in clob,    -- Сортировки
    NINCLUDE_DEF            in number,  -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob    -- Сериализованная таблица данных
  );

  /* Получение строк комплектации на основании маршрутного листа */
  procedure FCDELIVERYLISTSP_DG_GET
  (
    NFCROUTLST              in number,  -- Рег. номер маршрутного листа
    NPAGE_NUMBER            in number,  -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,  -- Количество записей на странице (0 - все)
    CORDERS                 in clob,    -- Сортировки
    NINCLUDE_DEF            in number,  -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob    -- Сериализованная таблица данных
  );

  /* Получение товарных запасов на основании маршрутного листа */
  procedure GOODSPARTIES_DG_GET
  (
    NFCROUTLST              in number,  -- Рег. номер маршрутного листа
    NPAGE_NUMBER            in number,  -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,  -- Количество записей на странице (0 - все)
    CORDERS                 in clob,    -- Сортировки
    NINCLUDE_DEF            in number,  -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob    -- Сериализованная таблица данных
  );

  /* Получение таблицы маршрутных листов, связанных со спецификацией плана с учетом типа */
  procedure FCROUTLST_DG_GET
  (
    NFCPRODPLANSP           in number,  -- Рег. номер связанной спецификации плана
    NTYPE                   in number,  -- Тип спецификации плана (0 - Деталь, 1 - Изделие/сборочная единица, 3/4 - ПиП)
    NPAGE_NUMBER            in number,  -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,  -- Количество записей на странице (0 - все)
    CORDERS                 in clob,    -- Сортировки
    NINCLUDE_DEF            in number,  -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob    -- Сериализованная таблица данных
  );

  /* Получение списка спецификаций планов и отчетов производства изделий для диаграммы Ганта */
  procedure FCPRODPLANSP_GET
  (
    NCRN                    in number,                     -- Рег. номер каталога
    NLEVEL                  in number := null,             -- Уровень отбора
    SSORT_FIELD             in varchar2 := 'DREP_DATE_TO', -- Поле сортировки
    COUT                    out clob,                      -- Список задач
    NMAX_LEVEL              out number                     -- Максимальный уровень иерархии
  );

  /* Инициализация каталогов раздела "Планы и отчеты производства изделий" для панели "Производственная программа" */
  procedure FCPRODPLAN_PP_CTLG_INIT
  (
    COUT                    out clob    -- Список каталогов раздела "Планы и отчеты производства изделий"
  );

  /* Изменение приоритета партии маршрутного листа */
  procedure FCROUTLST_PRIOR_PARTY_UPDATE
  (
    NFCROUTLST              in number,  -- Рег. номер маршрутного листа
    SPRIOR_PARTY            in varchar  -- Новое значение приоритета партии
  );
  
  /* Получение таблицы маршрутных листов, связанных со спецификацией плана */
  procedure FCROUTLST_DEPT_DG_GET
  (
    NFCPRODPLANSP           in number,  -- Рег. номер связанной спецификации плана
    NPAGE_NUMBER            in number,  -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,  -- Количество записей на странице (0 - все)
    CORDERS                 in clob,    -- Сортировки
    NINCLUDE_DEF            in number,  -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob    -- Сериализованная таблица данных
  );
  
  /* Получение таблицы строк маршрутного листа */
  procedure FCROUTLSTSP_DEPT_DG_GET
  (
    NFCROUTLST              in number,  -- Рег. номер маршрутного листа
    NPAGE_NUMBER            in number,  -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,  -- Количество записей на странице (0 - все)
    CORDERS                 in clob,    -- Сортировки
    NINCLUDE_DEF            in number,  -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob    -- Сериализованная таблица данных
  );

  /* Получение таблицы ПиП на основании маршрутного листа, связанных со спецификацией плана */
  procedure INCOMEFROMDEPS_DEPT_DG_GET
  (
    NFCPRODPLANSP           in number,  -- Рег. номер связанной спецификации плана
    NPAGE_NUMBER            in number,  -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,  -- Количество записей на странице (0 - все)
    CORDERS                 in clob,    -- Сортировки
    NINCLUDE_DEF            in number,  -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob    -- Сериализованная таблица данных
  );
  
  /* Получение таблицы спецификаций планов и отчетов производства изделий */
  procedure FCPRODPLANSP_DEPT_DG_GET
  (
    NFCPRODPLAN             in number,  -- Рег. номер планов и отчетов производства изделий
    NPAGE_NUMBER            in number,  -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,  -- Количество записей на странице (0 - все)
    CORDERS                 in clob,    -- Сортировки
    NINCLUDE_DEF            in number,  -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob    -- Сериализованная таблица данных
  );
  
  /* Инициализация записей раздела "Планы и отчеты производства изделий" */
  procedure FCPRODPLAN_DEPT_INIT
  (
    COUT                    out clob    -- Список записей раздела "Планы и отчеты производства изделий"
  );
  
  /* Выдать задания сменного задания */
  procedure FCJOBSSP_ISSUE
  (
    NFCJOBS                 in number   -- Рег. номер сменного задания
  );
  
  /* Исключение станка из операции сменного задания */
  procedure FCJOBSSP_EXC_EQCONFIG
  (
    NFCJOBSSP               in number   -- Рег. номер строки сменного задания
  );
  
  /* Включение станка в строку сменного задания */
  procedure FCJOBSSP_INC_EQCONFIG
  (
    NEQCONFIG               in number,  -- Рег. номер состава оборудования
    NFCJOBSSP               in number,  -- Рег. номер строки сменного задания
    NQUANT_PLAN             in number   -- Включаемое количество
  );
  
  /* Получение составов оборудования подразделения */
  procedure EQCONFIG_DG_GET
  (
    NFCJOBS                 in number,  -- Рег. номер сменного задания
    NPAGE_NUMBER            in number,  -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,  -- Количество записей на странице (0 - все)
    CORDERS                 in clob,    -- Сортировки
    NINCLUDE_DEF            in number,  -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob    -- Сериализованная таблица данных
  );
  
  /* Получение спецификации сменного задания */
  procedure FCJOBSSP_DG_GET
  (
    NFCJOBS                 in number,  -- Рег. номер сменного задания
    NPAGE_NUMBER            in number,  -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,  -- Количество записей на странице (0 - все)
    CORDERS                 in clob,    -- Сортировки
    NINCLUDE_DEF            in number,  -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob    -- Сериализованная таблица данных
  );
  
  /* Инициализация записей раздела "Планы и отчеты производства изделий" */
  procedure FCJOBS_INIT
  (
    COUT                    out clob    -- Список записей раздела "Сменные задания"
  );
  
  /* Получение количества рабочих часов в сменах подразделения */
  procedure INS_DEPARTMENT_WORKHOURS_GET
  (
    NSUBDIV                 in number,  -- Рег. номер подразделения
    NWORKHOURS              out number  -- Количество рабочих часов
  );
  
  /* Получение количества рабочих дней месяца */
  procedure ENPERIOD_WORKDAYS_GET
  (
    SMONTH_YEAR             in varchar2, -- Строковое представления месяца и года в формате (mm.yyyy)
    NWORKDAYS               out number   -- Количество рабочих дней
  );
  
  /* Получение таблицы доступных подразделений (цехов) */
  procedure INS_DEPARTMENT_DG_GET
  (
    SMONTH_YEAR             in varchar2, -- Строковое представления месяца и года в формате (mm.yyyy)
    NPAGE_NUMBER            in number,   -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,   -- Количество записей на странице (0 - все)
    NINCLUDE_DEF            in number,   -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob     -- Сериализованная таблица данных
  );
  
  /* Получение загрузки цеха */
  procedure FCJOBS_DEP_LOAD_DG_GET
  (
    NSUBDIV                 in number,   -- Рег. номер подразделения (цеха)
    SMONTH_YEAR             in varchar2, -- Строковое представления месяца и года в формате (mm.yyyy)
    NWORKHOURS              in number,   -- Количество рабочих часов
    NPAGE_NUMBER            in number,   -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,   -- Количество записей на странице (0 - все)
    CORDERS                 in clob,     -- Сортировки
    NINCLUDE_DEF            in number,   -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob     -- Сериализованная таблица данных
  );
  
  /* Получение таблицы маршрутных листов связанной записи "Производственная программа" */
  procedure FCROUTLST_DG_BY_LINKED_GET
  (
    NFCPRODPLANSP           in number,  -- Рег. номер связанной строки плана
    NPAGE_NUMBER            in number,  -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,  -- Количество записей на странице (0 - все)
    CORDERS                 in clob,    -- Сортировки
    NINCLUDE_DEF            in number,  -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob    -- Сериализованная таблица данных
  );
  
  /* Получение таблицы комплектовочных ведомостей связанной записи "Производственная программа" */
  procedure FCDELIVSH_DG_BY_LINKED_GET
  (
    NFCPRODPLANSP           in number,  -- Рег. номер связанной строки плана
    NPAGE_NUMBER            in number,  -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,  -- Количество записей на странице (0 - все)
    CORDERS                 in clob,    -- Сортировки
    NINCLUDE_DEF            in number,  -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob    -- Сериализованная таблица данных
  );
  
  /* Получение таблицы записей "Планы и отчеты производства изделий" */
  procedure FCPRODPLAN_GET
  (
    NCRN                    in number,  -- Рег. номер каталога
    COUT                    out clob    -- Сериализованная таблица данных
  );
  
  /* Инициализация каталогов раздела "Планы и отчеты производства изделий" для панели "Мониторинг сборки изделий" */
  procedure FCPRODPLAN_AM_CTLG_INIT
  (
    COUT                    out clob    -- Список каталогов раздела "Планы и отчеты производства изделий"
  );

  /* Считывание деталей производственного состава */
  procedure FCPRODCMP_DETAILS_GET
  (
    NFCPRODPLANSP           in number,  -- Рег. номер строки плана
    COUT                    out clob    -- Сериализованная таблица данных
  );

end PKG_P8PANELS_MECHREC;
/
create or replace package body PKG_P8PANELS_MECHREC as

  /* Константы - цвета отображения */
  SBG_COLOR_RED             constant PKG_STD.TSTRING := '#ff000080'; -- Цвет заливки красный
  SBG_COLOR_YELLOW          constant PKG_STD.TSTRING := '#e0db4480'; -- Цвет заливки желтый
  SBG_COLOR_GREEN           constant PKG_STD.TSTRING := '#90ee9080'; -- Цвет заливки зеленый
  SBG_COLOR_GREY            constant PKG_STD.TSTRING := '#d3d3d380'; -- Цвет заливки серый
  SBG_COLOR_BLACK           constant PKG_STD.TSTRING := '#00000080'; -- Цвет заливки черный
  STEXT_COLOR_ORANGE        constant PKG_STD.TSTRING := '#FF8C00';   -- Цвет текста оранжевый
  STEXT_COLOR_GREY          constant PKG_STD.TSTRING := '#555';      -- Цвет текста серый
  
  /* Константы - параметры отборов планов ("Производственная программа") */
  NFCPRODPLAN_CATEGORY      constant PKG_STD.TNUMBER := 1;      -- Категория планов "Производственная программа"
  NFCPRODPLAN_STATUS        constant PKG_STD.TNUMBER := 2;      -- Статус планов "Утвержден"
  SFCPRODPLAN_TYPE          constant PKG_STD.TSTRING := 'План'; -- Тип планов (мнемокод состояния)
  NMAX_TASKS                constant PKG_STD.TNUMBER := 10000;  -- Максимальное количество отображаемых задач
  
  /* Константы - классы задач плана ("Производственная программа") */
  NCLASS_WO_DEFICIT         constant PKG_STD.TNUMBER := 0; -- Без дефицита выпуска
  NCLASS_PART_DEFICIT       constant PKG_STD.TNUMBER := 1; -- С частичным дефицитом выпуска
  NCLASS_FULL_DEFICIT       constant PKG_STD.TNUMBER := 2; -- С полным дефицитом выпуска
  NCLASS_WITH_DEFICIT       constant PKG_STD.TNUMBER := 3; -- С дефицитом запуска или датой меньше текущей
  NCLASS_FUTURE_DATE        constant PKG_STD.TNUMBER := 4; -- Дата анализа еще не наступила
  NCLASS_WO_LINKS           constant PKG_STD.TNUMBER := 5; -- Задача без связи
  
  /* Константы - типы задач плана, содержание детализации ("Производственная программа") */
  NTASK_TYPE_RL_WITH_GP     constant PKG_STD.TNUMBER := 0;    -- Маршрутные листы с развертыванием товарных запасов
  NTASK_TYPE_RL_WITH_DL     constant PKG_STD.TNUMBER := 1;    -- Маршрутные листы с развертыванием комплектаций
  NTASK_TYPE_INC_DEPS       constant PKG_STD.TNUMBER := 2;    -- Приход из подразделений
  NTASK_TYPE_INC_DEPS_RL    constant PKG_STD.TNUMBER := 3;    -- Приход из подразделений и маршрутные листы
  NTASK_TYPE_RL             constant PKG_STD.TNUMBER := 4;    -- Маршрутные листы
  NTASK_TYPE_EMPTY          constant PKG_STD.TNUMBER := null; -- Нет детализации
  
  /* Константы - типы дней ("Загрузка цеха") */
  NDAY_TYPE_WORK_AFTER      constant PKG_STD.TNUMBER := 0; -- Рабочий день после текущей даты
  NDAY_TYPE_HOLIDAY_AFTER   constant PKG_STD.TNUMBER := 1; -- Выходной день после текущей даты
  NDAY_TYPE_WORK_BEFORE     constant PKG_STD.TNUMBER := 2; -- Рабочий день до текущей даты
  NDAY_TYPE_HOLIDAY_BEFORE  constant PKG_STD.TNUMBER := 3; -- Выходной день до текущей даты
  NDAY_TYPE_CURRENT_DAY     constant PKG_STD.TNUMBER := 4; -- Текущий день
  
  /* Константы - параметры отборов планов ("Производственный план цеха") */
  NFCPRODPLAN_DEPT_CTGR     constant PKG_STD.TNUMBER := 2; -- Категория планов "Цеховой план"
  
  /* Константы - параметры отборов планов ("Мониторинг сборки изделий") */
  NFCPRODPLAN_CATEGORY_MON  constant PKG_STD.TNUMBER := 0;      -- Категория планов "Первичный документ"
  NFCPRODPLAN_STATUS_MON    constant PKG_STD.TNUMBER := 2;      -- Статус планов "Утвержден"
  SFCPRODPLAN_TYPE_MON      constant PKG_STD.TSTRING := 'План'; -- Тип планов (мнемокод состояния)
  
  /* Константы - мнемокоды ед. измерения */
  SDICMUNTS_WD              constant PKG_STD.TSTRING := 'Ч/Ч'; -- Мнемокод ед. измерения нормочасов
  SDICMUNTS_MIN             constant PKG_STD.TSTRING := 'МИН'; -- Мнемокод ед. измерения минут
  SDICMUNTS_DAY             constant PKG_STD.TSTRING := 'Д';   -- Мнемокод ед. измерения дней
  
  /* Константы - параметры отборов сменных заданий */
  NFCJOBS_STATUS_NOT_WO     constant PKG_STD.TNUMBER := 0; -- Статус сменного задания "Не отработано"

  /* Константы - дополнительные атрибуты */
  STASK_ATTR_START_FACT     constant PKG_STD.TSTRING := 'start_fact';  -- Запущено
  STASK_ATTR_MAIN_QUANT     constant PKG_STD.TSTRING := 'main_quant';  -- Количество план
  STASK_ATTR_REL_FACT       constant PKG_STD.TSTRING := 'rel_fact';    -- Количество сдано
  STASK_ATTR_REP_DATE_TO    constant PKG_STD.TSTRING := 'rep_date_to'; -- Дата выпуска план
  STASK_ATTR_DL             constant PKG_STD.TSTRING := 'detail_list'; -- Связанные документы
  STASK_ATTR_TYPE           constant PKG_STD.TSTRING := 'type';        -- Тип (0 - Деталь, 1 - Изделие/сборочная единица)
  STASK_ATTR_MEAS           constant PKG_STD.TSTRING := 'meas';        -- Единица измнения
  
  /* Константы - дополнительные параметры */
  SCOL_PATTERN_DATE         constant PKG_STD.TSTRING := 'dd_mm_yyyy';         -- Паттерн для динамической колонки граф ("день_месяц_год")
  SFCROUTLSTSP_STATE_DOMAIN constant PKG_STD.TSTRING := 'TFCROUTLSTSP_STATE'; -- Мнемокод домена состояния спецификации маршрутного листа
  
  /* Константы - типовые присоединённые документы */
  SFLINKTYPE_PREVIEW        constant PKG_STD.TSTRING := 'Предпросмотр';     -- Тип ПД для изображений предпросмотра
  SFLINKTYPE_SVG_MODEL      constant PKG_STD.TSTRING := 'Векторная модель'; -- Тип ПД для SVG-модели
  
  /* Константы - дополнительные свойства */
  SDP_MODEL_ID              constant PKG_STD.TSTRING := 'ПУДП.MODEL_ID';       -- Идентификатор в SVG-модели
  SDP_MODEL_BG_COLOR        constant PKG_STD.TSTRING := 'ПУДП.MODEL_BG_COLOR'; -- Цвет заливки в SVG-модели
    
  /* Экземпляр дня загрузки цеха */
  type TJOB_DAY is record
  (
    DDATE                   PKG_STD.TLDATE, -- Дата дня загрузки цеха
    NVALUE                  PKG_STD.TQUANT, -- Значение доли трудоемкости смены
    NTYPE                   PKG_STD.TNUMBER -- Тип дня (0 - выполняемый, 1 - выполненный)
  );

  /* Коллекция дней загрузки цеха */
  type TJOB_DAYS is table of TJOB_DAY;

  /* Добавление дня в коллекцию дней загрузки цеха */
  procedure TJOB_DAYS_ADD
  (
    TDAYS                   in out nocopy TJOB_DAYS, -- Коллекция дней загрузки цеха
    DDATE                   in date,                 -- Дата дня загрузки цеха
    NVALUE                  in number,               -- Значение доли трудоемкости смены
    NTYPE                   in number,               -- Тип дня (0 - выполняемый, 1 - выполненный)
    BCLEAR                  in boolean := false      -- Признак очистки результирующей коллекции перед добавлением таблицы
  )
  is
  begin
    /* Инициализируем коллекцию таблиц документа */
    if ((TDAYS is null) or (BCLEAR)) then
      TDAYS := TJOB_DAYS();
    end if;
    /* Добавляем таблицу к документу */
    TDAYS.EXTEND();
    TDAYS(TDAYS.LAST).DDATE := DDATE;
    TDAYS(TDAYS.LAST).NVALUE := NVALUE;
    TDAYS(TDAYS.LAST).NTYPE := NTYPE;
  end TJOB_DAYS_ADD; 
  
  /* Инциализация списка маршрутных листов (с иерархией) */
  procedure UTL_FCROUTLST_IDENT_INIT
  (
    NFCPRODPLANSP           in number,  -- Рег. номер связанной спецификации плана
    NIDENT                  out number  -- Идентификатор отмеченных записей
  )
  is
    /* Рекурсивная процедура формирования списка маршрутных листов */
    procedure PUT_FCROUTLST
    (
      NIDENT                in number,       -- Идентификатор отмеченных записей
      NFCROUTLST            in number        -- Рег. номер маршрутного листа
    )
    is
      NTMP                  PKG_STD.TNUMBER; -- Буфер
    begin
      /* Добавление в список */
      begin
        P_SELECTLIST_INSERT(NIDENT => NIDENT, NDOCUMENT => NFCROUTLST, SUNITCODE => 'CostRouteLists', NRN => NTMP);
      exception
        when others then
          return;
      end;
      /* Маршрутные листы, связанные со строками добавленного */
      for RLST in (select distinct L.OUT_DOCUMENT as RN
                     from FCROUTLSTSP LS,
                          DOCLINKS    L
                    where LS.PRN = NFCROUTLST
                      and L.IN_DOCUMENT = LS.RN
                      and L.IN_UNITCODE = 'CostRouteListsSpecs'
                      and L.OUT_UNITCODE = 'CostRouteLists')
      loop
        /* Добавляем по данному листу */
        PUT_FCROUTLST(NIDENT => NIDENT, NFCROUTLST => RLST.RN);
      end loop;
    end PUT_FCROUTLST;
  begin
    /* Генерируем идентификатор */
    NIDENT := GEN_IDENT();
    /* Цикл по связанным напрямую маршрутным листам */
    for RLST in (select D.RN
                   from FCROUTLST D
                  where D.RN in (select L.OUT_DOCUMENT
                                   from DOCLINKS L
                                  where L.IN_DOCUMENT = NFCPRODPLANSP
                                    and L.IN_UNITCODE = 'CostProductPlansSpecs'
                                    and L.OUT_UNITCODE = 'CostRouteLists'))
    loop
      /* Рекурсивная процедура формирования списка маршрутных листов */
      PUT_FCROUTLST(NIDENT => NIDENT, NFCROUTLST => RLST.RN);
    end loop;
  end UTL_FCROUTLST_IDENT_INIT;
  
  /* Считывание записи маршрутного листа */
  procedure UTL_FCROUTLST_GET
  (
    NFCROUTLST              in number,            -- Рег. номер маршрутного листа
    RFCROUTLST              out FCROUTLST%rowtype -- Запись маршрутного листа
  )
  is
  begin
    /* Считываем запись маршрутного листа */
    begin
      select T.* into RFCROUTLST from FCROUTLST T where T.RN = NFCROUTLST;
    exception
      when others then
        PKG_MSG.RECORD_NOT_FOUND(NFLAG_SMART => 0, NDOCUMENT => NFCROUTLST, SUNIT_TABLE => 'FCROUTLST');
    end;
  end UTL_FCROUTLST_GET;
  
  /* Считывания рег. номера подразделения пользователя */
  function UTL_SUBDIV_RN_GET
  (
    NCOMPANY                in number,       -- Рег. номер организации
    SUSER                   in varchar2      -- Имя пользователя
  ) return                  number           -- Рег. номер подразделения
  is
    NRESULT                 PKG_STD.TNUMBER; -- Рег. номер подразделения
    NVERSION                PKG_STD.TREF;    -- Версия контрагентов
  begin
    /* Считываем версию контрагентов */
    FIND_VERSION_BY_COMPANY(NCOMPANY => NCOMPANY, SUNITCODE => 'AGNLIST', NVERSION => NVERSION);
    /* Проверяем подразделение по исполнению сотрудника пользователя */
    begin
      select C.DEPTRN
        into NRESULT
        from CLNPSPFM      C,
             CLNPSPFMTYPES CT
       where exists (select null
                from CLNPERSONS CP
               where exists (select null
                        from AGNLIST T
                       where T.PERS_AUTHID = SUSER
                         and CP.PERS_AGENT = T.RN
                         and T.VERSION = NVERSION)
                 and C.PERSRN = CP.RN
                 and CP.COMPANY = NCOMPANY)
         and C.COMPANY = NCOMPANY
         and C.BEGENG <= sysdate
         and (C.ENDENG >= sysdate or C.ENDENG is null)
         and C.CLNPSPFMTYPES = CT.RN
         and CT.IS_PRIMARY = 1
         and ROWNUM = 1;
    exception
      when others then
        NRESULT := 0;
    end;
    /* Возвращаем результат */
    return NRESULT;
  end UTL_SUBDIV_RN_GET;
  
  /* Проверка соответствия подразделения документа подразделению пользователя */
  function UTL_SUBDIV_CHECK
  (
    NCOMPANY                in number,       -- Рег. номер организации
    NSUBDIV                 in number,       -- Рег. номер подразделения
    SUSER                   in varchar2      -- Имя пользователя
  ) return                  number           -- Подразделение подходит (0 - нет, 1 - да)
  is
    NRESULT                 PKG_STD.TNUMBER; -- Подразделение подходит (0 - нет, 1 - да)
    NVERSION                PKG_STD.TREF;    -- Версия контрагентов
  begin
    /* Если рег. номер подразделения пустой */
    if (NSUBDIV is null) then
      /* Возвращаем 0 */
      return 0;
    end if;
    /* Считываем версию контрагентов */
    FIND_VERSION_BY_COMPANY(NCOMPANY => NCOMPANY, SUNITCODE => 'AGNLIST', NVERSION => NVERSION);
    /* Проверяем подразделение по исполнению сотрудника пользователя */
    begin
      select 1
        into NRESULT
        from DUAL
       where NSUBDIV in (select C.DEPTRN
                           from CLNPSPFM      C,
                                CLNPSPFMTYPES CT
                          where exists (select null
                                   from CLNPERSONS CP
                                  where exists (select null
                                           from AGNLIST T
                                          where T.PERS_AUTHID = SUSER
                                            and CP.PERS_AGENT = T.RN
                                            and T.VERSION = NVERSION)
                                    and C.PERSRN = CP.RN
                                    and CP.COMPANY = NCOMPANY)
                            and C.COMPANY = NCOMPANY
                            and C.BEGENG <= sysdate
                            and (C.ENDENG >= sysdate or C.ENDENG is null)
                            and C.CLNPSPFMTYPES = CT.RN
                            and CT.IS_PRIMARY = 1);
    exception
      when others then
        NRESULT := 0;
    end;
    /* Возвращаем результат */
    return NRESULT;
  end UTL_SUBDIV_CHECK;
  
  /* Проверка соответствия подразделения документа подразделению пользователя (по иерархии) */
  function UTL_SUBDIV_HIER_CHECK
  (
    NCOMPANY                in number,        -- Рег. номер организации
    NSUBDIV                 in number,        -- Рег. номер подразделения
    SUSER                   in varchar2,      -- Имя пользователя
    NSTART_SUBDIV           in number := null -- Рег. номер родительского подразделения
  ) return                  number            -- Подразделение подходит (0 - нет, 1 - да)
  is
    NRESULT                 PKG_STD.TNUMBER;  -- Подразделение подходит (0 - нет, 1 - да)
    NVERSION                PKG_STD.TREF;     -- Версия контрагентов
  begin
    /* Если рег. номер подразделения пустой */
    if (NSUBDIV is null) then
      /* Возвращаем 0 */
      return 0;
    end if;
    /* Если родительское подразделение не задано */
    if (NSTART_SUBDIV is null) then
      /* Считываем версию контрагентов */
      FIND_VERSION_BY_COMPANY(NCOMPANY => NCOMPANY, SUNITCODE => 'AGNLIST', NVERSION => NVERSION);
      /* Проверяем подразделение по исполнению сотрудника пользователя */
      begin
        select 1
          into NRESULT
          from DUAL
         where exists (select null
                  from INS_DEPARTMENT T,
                       (select C.DEPTRN
                          from CLNPSPFM      C,
                               CLNPSPFMTYPES CT
                         where exists (select null
                                  from CLNPERSONS CP
                                 where exists (select null
                                          from AGNLIST T
                                         where T.PERS_AUTHID = SUSER
                                           and CP.PERS_AGENT = T.RN
                                           and T.VERSION = NVERSION)
                                   and C.PERSRN = CP.RN
                                   and CP.COMPANY = NCOMPANY)
                           and C.COMPANY = NCOMPANY
                           and C.BEGENG <= sysdate
                           and (C.ENDENG >= sysdate or C.ENDENG is null)
                           and C.CLNPSPFMTYPES = CT.RN
                           and CT.IS_PRIMARY = 1) TMP
                 where T.RN = NSUBDIV
                   and ROWNUM = 1
                 start with T.RN = TMP.DEPTRN
                connect by prior T.RN = T.PRN);
      exception
        when others then
          NRESULT := 0;
      end;
    else
      /* Проверяем подразделение по исполнению сотрудника пользователя */
      begin
        select 1
          into NRESULT
          from DUAL
         where exists (select null
                  from INS_DEPARTMENT T
                 where T.RN = NSUBDIV
                   and ROWNUM = 1
                 start with T.RN = NSTART_SUBDIV
                connect by prior T.RN = T.PRN);
      exception
        when others then
          NRESULT := 0;
      end;
    end if;
    /* Возвращаем результат */
    return NRESULT;
  end UTL_SUBDIV_HIER_CHECK;
  
  /* Проверка наличия станка "В эксплуатации" в иерархии цеха */
  function UTL_INS_DEP_HIER_EQ_CHECK
  (
    NCOMPANY                in number,       -- Рег. номер организации
    NINS_DEPARTMENT         in number,       -- Рег. номер подразделения (цеха)
    DDATE_TO                in date          -- Дата по
  ) return                  number           -- Результат (0 - станка нет, 1 - станок есть)
  is
    NRESULT                 PKG_STD.TNUMBER; -- Результат (0 - станка нет, 1 - станок есть)
  begin
    /* Проверяем наличие станка "В эксплуатации" в иерархии цеха */
    begin
      select 1
        into NRESULT
        from INS_DEPARTMENT H
       where H.COMPANY = NCOMPANY
         and exists (select null
                from SUBDIVSEQ EQ,
                     EQCONFIG  EQC
               where EQ.PRN = H.RN
                 and EQC.RN = EQ.EQCONFIG
                 and EQC.OPER_DATE is not null
                 and EQC.OPER_DATE <= DDATE_TO
                 and ROWNUM = 1)
         and ROWNUM = 1
       start with H.RN = NINS_DEPARTMENT
      connect by prior H.RN = H.PRN;
    exception
      when others then
        NRESULT := 0;
    end;
    /* Возвращаем результат */
    return NRESULT;
  end UTL_INS_DEP_HIER_EQ_CHECK;
    
  /* Проверка наличия состава оборудования */
  procedure UTL_EQCONFIG_EXISTS
  (
    NEQCONFIG               in number,       -- Рег. номер состава оборудования
    NCOMPANY                in number        -- Рег. номер организации
  )
  is
    NEXISTS                 PKG_STD.TNUMBER; -- Буфер
  begin
    /* Проверяем наличие оборудования */
    begin
      select T.RN
        into NEXISTS
        from EQCONFIG T
       where T.RN = NEQCONFIG
         and T.COMPANY = NCOMPANY;
    exception
      when others then
        P_EXCEPTION(0, 'Рабочее место не найдено.');
    end;
  end UTL_EQCONFIG_EXISTS;
  
  /* Считывание рег. номера основной спецификации плана из "Производственная программа" */
  function UTL_FCPRODPLANSP_MAIN_GET
  (
    NCOMPANY                in number,    -- Рег. номер организации
    NFCPRODPLANSP           in number     -- Рег. номер связанной спецификации плана
  ) return                  number        -- Рег. номер основной спецификации плана из "Производственная программа"
  is
    NRESULT                 PKG_STD.TREF; -- Рег. номер основной спецификации плана из "Производственная программа"
  begin
    /* Поиск связанной спецификации из "Производственная программа" */
    begin
      select S.RN
        into NRESULT
        from DOCLINKS     T,
             FCPRODPLANSP S,
             FCPRODPLAN   P
       where T.OUT_DOCUMENT = NFCPRODPLANSP
         and T.IN_UNITCODE = 'CostProductPlansSpecs'
         and T.OUT_UNITCODE = 'CostProductPlansSpecs'
         and S.RN = T.IN_DOCUMENT
         and P.RN = S.PRN
         and P.CATEGORY = NFCPRODPLAN_CATEGORY
         and P.COMPANY = NCOMPANY
         and ROWNUM = 1;
    exception
      when others then
        NRESULT := null;
    end;
    /* Возвращаем результат */
    return NRESULT;
  end UTL_FCPRODPLANSP_MAIN_GET;
  
  /* Считывание записи строки сменного задания */
  function UTL_FCJOBSSP_GET
  (
    NCOMPANY                in number,        -- Рег. номер организации
    NFCJOBSSP               in number         -- Рег. номер строки сменного задания
  ) return                  FCJOBSSP%rowtype  -- Запись строки сменного задания
  is
    RFCJOBSSP               FCJOBSSP%rowtype; -- Запись строки сменного задания
  begin
    /* Считываем запись строки сменного задания */
    begin
      select T.*
        into RFCJOBSSP
        from FCJOBSSP T
       where T.RN = NFCJOBSSP
         and T.COMPANY = NCOMPANY;
    exception
      when others then
        P_EXCEPTION(0, 'Ошибка считывания строки сменного задания.');
    end;
    /* Возвращаем результат */
    return RFCJOBSSP;
  end UTL_FCJOBSSP_GET;
    
  /* Считывание количества рабочих часов с учетом перерыва */
  function UTL_WORK_TIME_GET
  (
    NTBOPERMODESP           in number         -- Рег. номер смены
  ) return                  number            -- Количество рабочих часов
  is
    NRESULT                 PKG_STD.TLNUMBER; -- Количество рабочих часов
  begin
    /* Определяем количество рабочих часов с учетом перерывов */
    begin
      select ROUND((TMP.WORK_MINUTS - COALESCE(TMP.BREAK_MINUTS, 0)) * 24 * 60, 3)
        into NRESULT
        from (select case BOS.SIGN_SHIFT
                       when 0 then
                        (BOS.END_TIME - BOS.BEG_TIME)
                       else
                        (BOS.END_TIME + 1 - BOS.BEG_TIME)
                     end WORK_MINUTS,
                     (select sum(case
                                   /* В один день */
                                   when BOS.SIGN_SHIFT = 0 then
                                    LEAST(BOS.END_TIME, BMS.END_TIME) - BMS.START_TIME
                                   /* Перерыв с переходом дня */
                                   when ((BOS.SIGN_SHIFT = 1) and (BMS.START_TIME >= BMS.END_TIME)) then
                                    (LEAST(BOS.END_TIME, BMS.END_TIME) + 1) - BMS.START_TIME
                                   /* Первый день */
                                   when ((BOS.SIGN_SHIFT = 1) and (BMS.START_TIME >= BOS.BEG_TIME)) then
                                    BMS.END_TIME - BMS.START_TIME
                                   /* Второй день */
                                   else
                                    LEAST(BOS.END_TIME, BMS.END_TIME) - BMS.START_TIME
                                 end) BREAK_MIN
                        from TBBREAKMODESP BMS
                       where BMS.PRN = BO.BREAKMODE
                         and (((BOS.SIGN_SHIFT = 0) and
                             ((BMS.START_TIME >= BOS.BEG_TIME) and (BMS.START_TIME < BOS.END_TIME))) or
                             ((BOS.SIGN_SHIFT = 1) and
                             ((BMS.START_TIME >= BOS.BEG_TIME) or (BMS.START_TIME < BOS.END_TIME))))) BREAK_MINUTS
                from TBOPERMODESP BOS,
                     TBOPERMODE   BO
               where BOS.RN = NTBOPERMODESP
                 and BO.RN = BOS.PRN) TMP;
    exception
      when others then
        NRESULT := null;
    end;
    /* Возвращаем результат */
    return NRESULT;
  end UTL_WORK_TIME_GET;
  
  /* Проверка наличия связанных маршрутных листов */
  function LINK_FCROUTLST_CHECK
  (
    NCOMPANY                in number,        -- Рег. номер организации
    NFCPRODPLANSP           in number,        -- Рег. номер спецификации плана
    NSTATE                  in number := null -- Состояние маршрутного листа
  ) return                  number            -- Наличие связанного МЛ (0 - нет, 1 - есть)
  is
    NRESULT                 PKG_STD.TNUMBER;  -- Наличие связанного МЛ (0 - нет, 1 - есть)
  begin
    begin
      select 1
        into NRESULT
        from DUAL
       where exists (select null
                from DOCLINKS  L,
                     FCROUTLST F
               where L.IN_DOCUMENT = NFCPRODPLANSP
                 and L.IN_UNITCODE = 'CostProductPlansSpecs'
                 and L.IN_COMPANY = NCOMPANY
                 and L.OUT_UNITCODE = 'CostRouteLists'
                 and L.OUT_COMPANY = NCOMPANY
                 and F.RN = L.OUT_DOCUMENT
                 and ((NSTATE is null) or ((NSTATE is not null) and (F.STATE = NSTATE)))
                 and ROWNUM = 1);
    exception
      when others then
        NRESULT := 0;
    end;
    /* Возвращаем результат */
    return NRESULT;
  end LINK_FCROUTLST_CHECK;
  
  /* Проверка наличия связанных приходов из подразделений */
  function LINK_INCOMEFROMDEPS_CHECK
  (
    NCOMPANY                in number,        -- Рег. номер организации
    NFCPRODPLANSP           in number,        -- Рег. номер спецификации плана
    NSTATE                  in number := null -- Состояние ПиП
  ) return                  number            -- Наличие связанного ПиП (0 - нет, 1 - есть)
  is
    NRESULT                 PKG_STD.TNUMBER;  -- Наличие связанного ПиП (0 - нет, 1 - есть)
    NFCROUTLST_IDENT        PKG_STD.TREF;     -- Рег. номер идентификатора отмеченных записей маршрутных листов
  begin
    /* Инициализируем список маршрутных листов */
    UTL_FCROUTLST_IDENT_INIT(NFCPRODPLANSP => NFCPRODPLANSP, NIDENT => NFCROUTLST_IDENT);
    /* Проверяем наличие */
    begin
      select 1
        into NRESULT
        from DUAL
       where exists (select null
                from DOCLINKS       L,
                     INCOMEFROMDEPS F
               where L.IN_DOCUMENT = NFCPRODPLANSP
                 and L.IN_UNITCODE = 'CostProductPlansSpecs'
                 and L.OUT_UNITCODE = 'IncomFromDeps'
                 and L.OUT_COMPANY = NCOMPANY
                 and F.RN = L.OUT_DOCUMENT
                 and F.COMPANY = NCOMPANY
                 and ((NSTATE is null) or ((NSTATE is not null) and (F.DOC_STATE = NSTATE)))
                 and ROWNUM = 1)
          or exists (select null
                from INCOMEFROMDEPS F
               where F.RN in (select L.OUT_DOCUMENT
                                from SELECTLIST SL,
                                     DOCLINKS   L
                               where SL.IDENT = NFCROUTLST_IDENT
                                 and SL.UNITCODE = 'CostRouteLists'
                                 and L.IN_DOCUMENT = SL.DOCUMENT
                                 and L.IN_UNITCODE = 'CostRouteLists'
                                 and L.OUT_UNITCODE = 'IncomFromDeps'));
    exception
      when others then
        NRESULT := 0;
    end;
    /* Очищаем отмеченные маршрутные листы */
    P_SELECTLIST_CLEAR(NIDENT => NFCROUTLST_IDENT);
    /* Возвращаем результат */
    return NRESULT;
  exception
    when others then
      /* Очищаем отмеченные маршрутные листы */
      P_SELECTLIST_CLEAR(NIDENT => NFCROUTLST_IDENT);
      raise;
  end LINK_INCOMEFROMDEPS_CHECK;
  
  /*
    Процедуры панели "Производственная программа"
  */

  /* Получение таблицы ПиП на основании маршрутного листа, связанных со спецификацией плана */
  procedure INCOMEFROMDEPS_DG_GET
  (
    NFCPRODPLANSP           in number,                             -- Рег. номер связанной спецификации плана
    NTYPE                   in number,                             -- Тип спецификации плана (2 - Не включать "Состояние", 3 - включать)
    NPAGE_NUMBER            in number,                             -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- Количество записей на странице (0 - все)
    CORDERS                 in clob,                               -- Сортировки
    NINCLUDE_DEF            in number,                             -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob                               -- Сериализованная таблица данных
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    RO                      PKG_P8PANELS_VISUAL.TORDERS;           -- Сортировки
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- Описание таблицы
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы
    NROW_FROM               PKG_STD.TREF;                          -- Номер строки с
    NROW_TO                 PKG_STD.TREF;                          -- Номер строки по
    CSQL                    clob;                                  -- Буфер для запроса
    ICURSOR                 integer;                               -- Курсор для исполнения запроса
    NFCROUTLST_IDENT        PKG_STD.TREF;                          -- Рег. номер идентификатора отмеченных записей маршрутных листов
  begin
    /* Читем сортировки */
    RO := PKG_P8PANELS_VISUAL.TORDERS_FROM_XML(CORDERS => CORDERS);
    /* Преобразуем номер и размер страницы в номер строк с и по */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* Инициализируем таблицу данных */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE();
    /* Описываем колонки таблицы данных */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => 'Рег. номер',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SDOC_INFO',
                                               SCAPTION   => 'Накладная',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true);
    /* Если тип "Приход из подразделений и маршрутные листы", то необходимо включать состояние */
    if (NTYPE = NTASK_TYPE_INC_DEPS_RL) then
      PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                                 SNAME      => 'SDOC_STATE',
                                                 SCAPTION   => 'Состояние',
                                                 SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                                 BVISIBLE   => true);
    end if;
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DWORK_DATE',
                                               SCAPTION   => 'Дата сдачи',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SDOC_VALID_INFO',
                                               SCAPTION   => 'Маршрутный лист',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SOUT_DEPARTMENT',
                                               SCAPTION   => 'Сдающий цех',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SSTORE',
                                               SCAPTION   => 'Склад цеха потребителя',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NQUANT_FACT',
                                               SCAPTION   => 'Количество сдано',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    /* Инициализируем список маршрутных листов */
    UTL_FCROUTLST_IDENT_INIT(NFCPRODPLANSP => NFCPRODPLANSP, NIDENT => NFCROUTLST_IDENT);
    /* Обходим данные */
    begin
      /* Добавляем подсказку совместимости */
      CSQL := PKG_SQL_BUILD.COMPATIBLE(SSQL => CSQL);
      /* Формируем запрос */
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => 'select *');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '  from (select D.*,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => PKG_SQL_BUILD.SQLROWNUM() || ' NROW');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '          from (select T.RN NRN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       DT.DOCCODE ||');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       '', '' || TRIM(T.DOC_PREF) ||');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       ''-'' || TRIM(T.DOC_NUMB) ||');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       '', '' || TO_CHAR(T.DOC_DATE, ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'dd.mm.yyyy') || ') as SDOC_INFO,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       case T.DOC_STATE');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                         when 0 then');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'Не отработан'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                         when 1 then');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'Отработан как план'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                         when 2 then');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'Отработан как факт'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                         else');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       end SDOC_STATE,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.WORK_DATE DWORK_DATE,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       DTV.DOCCODE ||');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       '', '' || T.VALID_DOCNUMB || ');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       '', '' || TO_CHAR(T.VALID_DOCDATE, ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'dd.mm.yyyy') || ') as SDOC_VALID_INFO,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       D.CODE SOUT_DEPARTMENT,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       S.AZS_NUMBER SSTORE,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       (select SUM(SP.QUANT_FACT)');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                          from INCOMEFROMDEPSSPEC SP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                         where SP.PRN = T.RN) NQUANT_FACT');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                  from INCOMEFROMDEPS T left outer join DOCTYPES DTV on T.VALID_DOCTYPE = DTV.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       left outer join INS_DEPARTMENT D on T.OUT_DEPARTMENT = D.RN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       DOCTYPES DT,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       AZSAZSLISTMT S');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                 where ((T.RN in (select L.OUT_DOCUMENT');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                    from DOCLINKS L');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                   where L.IN_DOCUMENT = :NFCPRODPLANSP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                     and L.IN_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostProductPlansSpecs'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                     and L.OUT_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'IncomFromDeps') || '))');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                        or (T.RN in (select L.OUT_DOCUMENT');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                       from SELECTLIST SL,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                            DOCLINKS   L');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                      where SL.IDENT       = :NFCROUTLST_IDENT');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        and SL.UNITCODE    = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        and L.IN_DOCUMENT  = SL."DOCUMENT"');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        and L.IN_UNITCODE  = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        and L.OUT_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'IncomFromDeps') || ')))');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.COMPANY = :NCOMPANY');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.DOC_TYPE = DT.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.STORE = S.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                %ORDER_BY%) D) F');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => ' where F.NROW between :NROW_FROM and :NROW_TO');
      /* Учтём сортировки */
      PKG_P8PANELS_VISUAL.TORDERS_SET_QUERY(RDATA_GRID => RDG, RORDERS => RO, SPATTERN => '%ORDER_BY%', CSQL => CSQL);
      /* Разбираем его */
      ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
      PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
      /* Делаем подстановку параметров */
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NCOMPANY', NVALUE => NCOMPANY);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NFCPRODPLANSP', NVALUE => NFCPRODPLANSP);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NFCROUTLST_IDENT', NVALUE => NFCROUTLST_IDENT);
      /* Описываем структуру записи курсора */
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 1);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 2);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 3);
      PKG_SQL_DML.DEFINE_COLUMN_DATE(ICURSOR => ICURSOR, IPOSITION => 4);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 5);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 6);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 7);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 8);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 9);
      /* Делаем выборку */
      if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
        null;
      end if;
      /* Обходим выбранные записи */
      while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
      loop
        /* Добавляем колонки с данными */
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NRN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 1,
                                              BCLEAR    => true);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SDOC_INFO',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 2);
        /* Если тип "Приход из подразделений и маршрутные листы", то необходимо включать состояние */
        if (NTYPE = NTASK_TYPE_INC_DEPS_RL) then
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                                SNAME     => 'SDOC_STATE',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 3);
        end if;
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLD(RROW      => RDG_ROW,
                                              SNAME     => 'DWORK_DATE',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 4);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SDOC_VALID_INFO',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 5);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SOUT_DEPARTMENT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 6);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SSTORE', ICURSOR => ICURSOR, NPOSITION => 7);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NQUANT_FACT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 8);
        /* Добавляем строку в таблицу */
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
      end loop;
    exception
      when others then
        PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
        raise;
    end;
    /* Очищаем отмеченные маршрутные листы */
    P_SELECTLIST_CLEAR(NIDENT => NFCROUTLST_IDENT);
    /* Сериализуем описание */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  exception
    when others then
      /* Очищаем отмеченные маршрутные листы */
      P_SELECTLIST_CLEAR(NIDENT => NFCROUTLST_IDENT);
      raise;
  end INCOMEFROMDEPS_DG_GET;

  /* Получение таблицы строк комплектации на основании маршрутного листа */
  procedure FCDELIVERYLISTSP_DG_GET
  (
    NFCROUTLST              in number,                             -- Рег. номер маршрутного листа
    NPAGE_NUMBER            in number,                             -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- Количество записей на странице (0 - все)
    CORDERS                 in clob,                               -- Сортировки
    NINCLUDE_DEF            in number,                             -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob                               -- Сериализованная таблица данных
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    RO                      PKG_P8PANELS_VISUAL.TORDERS;           -- Сортировки
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- Описание таблицы
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы
    NROW_FROM               PKG_STD.TREF;                          -- Номер строки с
    NROW_TO                 PKG_STD.TREF;                          -- Номер строки по
    CSQL                    clob;                                  -- Буфер для запроса
    ICURSOR                 integer;                               -- Курсор для исполнения запроса
  begin
    /* Читем сортировки */
    RO := PKG_P8PANELS_VISUAL.TORDERS_FROM_XML(CORDERS => CORDERS);
    /* Преобразуем номер и размер страницы в номер строк с и по */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* Инициализируем таблицу данных */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE();
    /* Описываем колонки таблицы данных */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => 'Рег. номер',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SMATRESPL_CODE',
                                               SCAPTION   => 'Обозначение',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SMATRESPL_NAME',
                                               SCAPTION   => 'Наименование',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NPROD_QUANT',
                                               SCAPTION   => 'Применяемость',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NQUANT_PLAN',
                                               SCAPTION   => 'Количество план',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NREST',
                                               SCAPTION   => 'Остаток',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NQUANT_FACT',
                                               SCAPTION   => 'Скомплектовано',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DRES_DATE_TO',
                                               SCAPTION   => 'Зарезервировано',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SMATRESPL_NOMEN',
                                               SCAPTION   => 'Номенклатура',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true);
    /* Обходим данные */
    begin
      /* Добавляем подсказку совместимости */
      CSQL := PKG_SQL_BUILD.COMPATIBLE(SSQL => CSQL);
      /* Формируем запрос */
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => 'select *');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '  from (select D.*,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => PKG_SQL_BUILD.SQLROWNUM() || ' NROW');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '          from (select min(T.RN) NRN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.RES_DATE_TO DRES_DATE_TO,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       NP.NOMEN_CODE SMATRESPL_NOMEN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       CP.CODE SMATRESPL_CODE,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       CP."NAME" SMATRESPL_NAME,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.PROD_QUANT NPROD_QUANT,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       sum(T.QUANT_PLAN) NQUANT_PLAN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.REST NREST,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       sum(T.QUANT_FACT) NQUANT_FACT');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                  from DOCLINKS DL,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       FCDELIVERYLIST TL,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       FCDELIVERYLISTSP T,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       FCMATRESOURCE CP left outer join DICNOMNS NP on CP.NOMENCLATURE = NP.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                 where DL.IN_DOCUMENT = :NFCROUTLST');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and DL.IN_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and DL.OUT_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostDeliveryLists'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and TL.RN = DL.OUT_DOCUMENT');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and TL.COMPANY = :NCOMPANY');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.PRN = TL.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.MATRESPL = CP.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and exists (select null from V_USERPRIV UP where (UP."CATALOG" = T.CRN))');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and exists (select null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 from V_USERPRIV UP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                where UP.JUR_PERS = T.JUR_PERS');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostDeliveryLists') || ')');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                 group by T.RES_DATE_TO, NP.NOMEN_CODE, CP.CODE, CP."NAME", T.PROD_QUANT, T.REST');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                 %ORDER_BY%) D) F');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => ' where F.NROW between :NROW_FROM and :NROW_TO');
      /* Учтём сортировки */
      PKG_P8PANELS_VISUAL.TORDERS_SET_QUERY(RDATA_GRID => RDG, RORDERS => RO, SPATTERN => '%ORDER_BY%', CSQL => CSQL);
      /* Разбираем его */
      ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
      PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
      /* Делаем подстановку параметров */
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NCOMPANY', NVALUE => NCOMPANY);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NFCROUTLST', NVALUE => NFCROUTLST);
      /* Описываем структуру записи курсора */
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 1);
      PKG_SQL_DML.DEFINE_COLUMN_DATE(ICURSOR => ICURSOR, IPOSITION => 2);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 3);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 4);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 5);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 6);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 7);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 8);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 9);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 10);
      /* Делаем выборку */
      if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
        null;
      end if;
      /* Обходим выбранные записи */
      while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
      loop
        /* Добавляем колонки с данными */
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NRN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 1,
                                              BCLEAR    => true);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLD(RROW      => RDG_ROW,
                                              SNAME     => 'DRES_DATE_TO',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 2);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SMATRESPL_NOMEN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 3);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SMATRESPL_CODE',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 4);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SMATRESPL_NAME',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 5);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NPROD_QUANT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 6);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NQUANT_PLAN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 7);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW => RDG_ROW, SNAME => 'NREST', ICURSOR => ICURSOR, NPOSITION => 8);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NQUANT_FACT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 9);
        /* Добавляем строку в таблицу */
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
      end loop;
    exception
      when others then
        PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
        raise;
    end;
    /* Сериализуем описание */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  end FCDELIVERYLISTSP_DG_GET;

  /* Получение таблицы товарных запасов на основании маршрутного листа */
  procedure GOODSPARTIES_DG_GET
  (
    NFCROUTLST              in number,                             -- Рег. номер маршрутного листа
    NPAGE_NUMBER            in number,                             -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- Количество записей на странице (0 - все)
    CORDERS                 in clob,                               -- Сортировки
    NINCLUDE_DEF            in number,                             -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob                               -- Сериализованная таблица данных
  )
  is
    NSTORAGE                PKG_STD.TREF;                          -- Рег. номер склада списания
    NSTORAGE_IN             PKG_STD.TREF;                          -- Рег. номер склада получения
    NNOMENCLATURE           PKG_STD.TREF;                          -- Рег. номер номенклатуры основного материала
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    RO                      PKG_P8PANELS_VISUAL.TORDERS;           -- Сортировки
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- Описание таблицы
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы
    NROW_FROM               PKG_STD.TREF;                          -- Номер строки с
    NROW_TO                 PKG_STD.TREF;                          -- Номер строки по
    CSQL                    clob;                                  -- Буфер для запроса
    ICURSOR                 integer;                               -- Курсор для исполнения запроса
    DDATE                   PKG_STD.TLDATE;                        -- Дата с/по
  begin
    /* Считываем информацию из маршрутного листа */
    begin
      select T.STORAGE,
             T.STORAGE_IN,
             F.NOMENCLATURE
        into NSTORAGE,
             NSTORAGE_IN,
             NNOMENCLATURE
        from FCROUTLST     T,
             FCMATRESOURCE F
       where T.MATRES_PLAN = F.RN(+)
         and T.RN = NFCROUTLST;
    exception
      when others then
        NSTORAGE      := null;
        NSTORAGE_IN   := null;
        NNOMENCLATURE := null;
    end;
    /* Если номенклатура не указана */
    if ((NNOMENCLATURE is null) or ((NSTORAGE is null) and (NSTORAGE_IN is null))) then
      /* Не идем дальше */
      return;
    end if;
    /* Инициализируем даты */
    DDATE := TRUNC(sysdate);
    /* Читем сортировки */
    RO := PKG_P8PANELS_VISUAL.TORDERS_FROM_XML(CORDERS => CORDERS);
    /* Преобразуем номер и размер страницы в номер строк с и по */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* Описываем колонки таблицы данных */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SINDOC',
                                               SCAPTION   => 'Партия',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SSTORE',
                                               SCAPTION   => 'Склад',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NSALE',
                                               SCAPTION   => 'К продаже',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRESTFACT',
                                               SCAPTION   => 'Фактический остаток',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRESERV',
                                               SCAPTION   => 'Резерв',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               BORDER     => true,
                                               BFILTER    => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SPRICEMEAS',
                                               SCAPTION   => 'Единица измерения',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    /* Обходим данные */
    begin
      /* Добавляем подсказку совместимости */
      CSQL := PKG_SQL_BUILD.COMPATIBLE(SSQL => CSQL);
      /* Формируем запрос */
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => 'select *');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '  from (select D.*,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => PKG_SQL_BUILD.SQLROWNUM() || ' NROW');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '          from (select I.CODE SINDOC,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       AZ.AZS_NUMBER SSTORE,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       least(H.MIN_RESTPLAN,H.MIN_RESTFACT) NSALE,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       H.RESTFACT NRESTFACT,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       H.RESERV NRESERV,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       case coalesce(GRP.NMEASTYPE, 0)');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                         when 0 then MU1.MEAS_MNEMO');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                         when 1 then MU2.MEAS_MNEMO');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                         when 2 then MU3.MEAS_MNEMO');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       end SPRICEMEAS');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                  from GOODSPARTIES G,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       NOMMODIF MF,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       DICNOMNS NOM left outer join DICMUNTS MU2 on NOM.UMEAS_ALT = MU2.RN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       GOODSSUPPLYHIST H left outer join NOMNMODIFPACK PAC on H.NOMNMODIFPACK = PAC.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       left outer join NOMNPACK NPAC on PAC.NOMENPACK = NPAC.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       left outer join DICMUNTS MU3 on NPAC.UMEAS = MU3.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       left outer join V_GOODSSUPPLY_REGPRICE GRP on H.RN = GRP.NGOODSSUPPLYHIST,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       INCOMDOC I,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       GOODSSUPPLY S,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       DICMUNTS MU1,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       AZSAZSLISTMT AZ');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                 where G.COMPANY = :NCOMPANY');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and G.NOMMODIF = MF.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and NOM.RN = MF.PRN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and NOM.RN = :NNOMENCLATURE');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and I.RN = G.INDOC');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and S.PRN = G.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and (((:NSTORAGE is not null) and (S.STORE = :NSTORAGE)) or ((:NSTORAGE_IN is not null) and (S.STORE = :NSTORAGE_IN)))');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and H.PRN = S.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and AZ.RN = S.STORE');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and H.DATE_FROM <= :DDATE');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and (H.DATE_TO >= :DDATE or H.DATE_TO is null)');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and NOM.UMEAS_MAIN = MU1.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and H.RESTFACT <> ' || PKG_SQL_BUILD.WRAP_NUM(NVALUE => 0));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and exists (select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UP I_USERPRIV_JUR_PERS_ROLEID)') || ' null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 from USERPRIV UP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                where UP.JUR_PERS = G.JUR_PERS');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'GoodsParties'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.ROLEID in (select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UR I_USERROLES_AUTHID_FK)') || ' UR.ROLEID');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                      from USERROLES UR');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                     where UR.AUTHID = UTILIZER())');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                union all');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UP I_USERPRIV_JUR_PERS_AUTHID)') || ' null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 from USERPRIV UP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                where UP.JUR_PERS = G.JUR_PERS');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'GoodsParties'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.AUTHID   = UTILIZER())');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                %ORDER_BY%) D) F');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => ' where F.NROW between :NROW_FROM and :NROW_TO');
      /* Учтём сортировки */
      PKG_P8PANELS_VISUAL.TORDERS_SET_QUERY(RDATA_GRID => RDG, RORDERS => RO, SPATTERN => '%ORDER_BY%', CSQL => CSQL);
      /* Разбираем его */
      ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
      PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
      /* Делаем подстановку параметров */
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NCOMPANY', NVALUE => NCOMPANY);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NNOMENCLATURE', NVALUE => NNOMENCLATURE);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NSTORAGE', NVALUE => NSTORAGE);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NSTORAGE_IN', NVALUE => NSTORAGE_IN);
      PKG_SQL_DML.BIND_VARIABLE_DATE(ICURSOR => ICURSOR, SNAME => 'DDATE', DVALUE => DDATE);
      /* Описываем структуру записи курсора */
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 1);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 2);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 3);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 4);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 5);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 6);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 7);
      /* Делаем выборку */
      if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
        null;
      end if;
      /* Обходим выбранные записи */
      while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
      loop
        /* Добавляем колонки с данными */
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SINDOC',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 1,
                                              BCLEAR    => true);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SSTORE', ICURSOR => ICURSOR, NPOSITION => 2);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW => RDG_ROW, SNAME => 'NSALE', ICURSOR => ICURSOR, NPOSITION => 3);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NRESTFACT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 4);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW => RDG_ROW, SNAME => 'NRESERV', ICURSOR => ICURSOR, NPOSITION => 5);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SPRICEMEAS',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 6);
        /* Добавляем строку в таблицу */
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
      end loop;
    exception
      when others then
        PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
        raise;
    end;
    /* Сериализуем описание */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  end GOODSPARTIES_DG_GET;

  /* Получение таблицы маршрутных листов, связанных со спецификацией плана (по детали) */
  procedure FCROUTLST_DG_BY_DTL
  (
    NFCPRODPLANSP           in number,                             -- Рег. номер связанной спецификации плана
    NPAGE_NUMBER            in number,                             -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- Количество записей на странице (0 - все)
    CORDERS                 in clob,                               -- Сортировки
    NINCLUDE_DEF            in number,                             -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob                               -- Сериализованная таблица данных
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    RO                      PKG_P8PANELS_VISUAL.TORDERS;           -- Сортировки
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- Описание таблицы
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы
    NROW_FROM               PKG_STD.TREF;                          -- Номер строки с
    NROW_TO                 PKG_STD.TREF;                          -- Номер строки по
    CSQL                    clob;                                  -- Буфер для запроса
    ICURSOR                 integer;                               -- Курсор для исполнения запроса
  begin
    /* Читем сортировки */
    RO := PKG_P8PANELS_VISUAL.TORDERS_FROM_XML(CORDERS => CORDERS);
    /* Преобразуем номер и размер страницы в номер строк с и по */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* Инициализируем таблицу данных */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE();
    /* Описываем колонки таблицы данных */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => 'Рег. номер',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SDOCPREF',
                                               SCAPTION   => 'Префикс',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SDOCNUMB',
                                               SCAPTION   => 'Номер',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DEXEC_DATE',
                                               SCAPTION   => 'Дата запуска',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SMATRES_PLAN_NOMEN',
                                               SCAPTION   => 'Номенклатура основного материала',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SMATRES_PLAN_NAME',
                                               SCAPTION   => 'Наименование основного материала',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NQUANT',
                                               SCAPTION   => 'Количество запуска',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NQUANT_PLAN',
                                               SCAPTION   => 'Выдать по норме',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    /* Обходим данные */
    begin
      /* Добавляем подсказку совместимости */
      CSQL := PKG_SQL_BUILD.COMPATIBLE(SSQL => CSQL);
      /* Формируем запрос */
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => 'select *');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '  from (select D.*,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => PKG_SQL_BUILD.SQLROWNUM() || ' NROW');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '          from (select T.RN NRN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.DOCPREF SDOCPREF,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.DOCNUMB SDOCNUMB,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.EXEC_DATE DEXEC_DATE,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       (select NM2.NOMEN_CODE from DICNOMNS NM2 where F3.NOMENCLATURE = NM2.RN) SMATRES_PLAN_NOMEN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       F3."NAME" SMATRES_PLAN_NAME,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.QUANT NQUANT,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.QUANT_PLAN NQUANT_PLAN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                  from FCROUTLST T');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       left outer join FCMATRESOURCE F3 on T.MATRES_PLAN = F3.RN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       DOCLINKS DL');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                 where DL.IN_DOCUMENT = :NFCPRODPLANSP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and DL.IN_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostProductPlansSpecs'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and DL.OUT_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.RN = DL.OUT_DOCUMENT');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.COMPANY = :NCOMPANY');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T."STATE" = ' || PKG_SQL_BUILD.WRAP_NUM(NVALUE => 0));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and exists (select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UP I_USERPRIV_CATALOG_ROLEID)') || ' null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 from USERPRIV UP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                where UP."CATALOG" = T.CRN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.ROLEID in (select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UR I_USERROLES_AUTHID_FK)') || ' UR.ROLEID');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                      from USERROLES UR');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                     where UR.AUTHID = UTILIZER())');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                union all');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UP I_USERPRIV_CATALOG_AUTHID)') || ' null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 from USERPRIV UP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                where UP."CATALOG" = T.CRN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.AUTHID  = UTILIZER())');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and exists (select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UP I_USERPRIV_JUR_PERS_ROLEID)') || ' null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 from USERPRIV UP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                where UP.JUR_PERS = T.JUR_PERS');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.ROLEID in (select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UR I_USERROLES_AUTHID_FK)') || ' UR.ROLEID');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                      from USERROLES UR');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                     where UR.AUTHID = UTILIZER())');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                union all');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UP I_USERPRIV_JUR_PERS_AUTHID)') || ' null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 from USERPRIV UP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                where UP.JUR_PERS = T.JUR_PERS');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.AUTHID = UTILIZER())');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                %ORDER_BY%) D) F');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => ' where F.NROW between :NROW_FROM and :NROW_TO');
      /* Учтём сортировки */
      PKG_P8PANELS_VISUAL.TORDERS_SET_QUERY(RDATA_GRID => RDG, RORDERS => RO, SPATTERN => '%ORDER_BY%', CSQL => CSQL);
      /* Разбираем его */
      ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
      PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
      /* Делаем подстановку параметров */
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NCOMPANY', NVALUE => NCOMPANY);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NFCPRODPLANSP', NVALUE => NFCPRODPLANSP);
      /* Описываем структуру записи курсора */
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 1);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 2);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 3);
      PKG_SQL_DML.DEFINE_COLUMN_DATE(ICURSOR => ICURSOR, IPOSITION => 4);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 5);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 6);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 7);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 8);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 9);
      /* Делаем выборку */
      if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
        null;
      end if;
      /* Обходим выбранные записи */
      while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
      loop
        /* Добавляем колонки с данными */
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NRN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 1,
                                              BCLEAR    => true);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SDOCPREF',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 2);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SDOCNUMB', ICURSOR => ICURSOR, NPOSITION => 3);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLD(RROW      => RDG_ROW,
                                              SNAME     => 'DEXEC_DATE',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 4);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SMATRES_PLAN_NOMEN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 5);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SMATRES_PLAN_NAME',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 6);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NQUANT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 7);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NQUANT_PLAN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 8);
        /* Добавляем строку в таблицу */
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
      end loop;
    exception
      when others then
        PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
        raise;
    end;
    /* Сериализуем описание */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  end FCROUTLST_DG_BY_DTL;

  /* Получение таблицы маршрутных листов, связанных со спецификацией плана (по изделию) */
  procedure FCROUTLST_DG_BY_PRDCT
  (
    NFCPRODPLANSP           in number,                             -- Рег. номер связанной спецификации плана
    NPAGE_NUMBER            in number,                             -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- Количество записей на странице (0 - все)
    CORDERS                 in clob,                               -- Сортировки
    NINCLUDE_DEF            in number,                             -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob                               -- Сериализованная таблица данных
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    RO                      PKG_P8PANELS_VISUAL.TORDERS;           -- Сортировки
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- Описание таблицы
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы
    NROW_FROM               PKG_STD.TREF;                          -- Номер строки с
    NROW_TO                 PKG_STD.TREF;                          -- Номер строки по
    CSQL                    clob;                                  -- Буфер для запроса
    ICURSOR                 integer;                               -- Курсор для исполнения запроса
  begin
    /* Читем сортировки */
    RO := PKG_P8PANELS_VISUAL.TORDERS_FROM_XML(CORDERS => CORDERS);
    /* Преобразуем номер и размер страницы в номер строк с и по */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* Инициализируем таблицу данных */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE();
    /* Описываем колонки таблицы данных */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => 'Рег. номер',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SDOCPREF',
                                               SCAPTION   => 'Префикс',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SDOCNUMB',
                                               SCAPTION   => 'Номер',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DEXEC_DATE',
                                               SCAPTION   => 'Дата запуска',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NQUANT',
                                               SCAPTION   => 'Количество запуска',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DREL_DATE',
                                               SCAPTION   => 'Дата выпуска',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NREL_QUANT',
                                               SCAPTION   => 'Количество выпуска',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    /* Обходим данные */
    begin
      /* Добавляем подсказку совместимости */
      CSQL := PKG_SQL_BUILD.COMPATIBLE(SSQL => CSQL);
      /* Формируем запрос */
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => 'select *');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '  from (select D.*,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => PKG_SQL_BUILD.SQLROWNUM() || ' NROW');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '          from (select T.RN        NRN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.DOCPREF   SDOCPREF,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.DOCNUMB   SDOCNUMB,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.EXEC_DATE DEXEC_DATE,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.QUANT     NQUANT,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.REL_DATE  DREL_DATE,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.REL_QUANT NREL_QUANT');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                  from FCROUTLST T,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       DOCLINKS DL');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                 where DL.IN_DOCUMENT = :NFCPRODPLANSP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and DL.IN_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostProductPlansSpecs'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and DL.OUT_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.RN = DL.OUT_DOCUMENT');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.COMPANY = :NCOMPANY');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T."STATE" = ' || PKG_SQL_BUILD.WRAP_NUM(NVALUE => 0));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and exists (select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UP I_USERPRIV_CATALOG_ROLEID)') || ' null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 from USERPRIV UP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                where UP."CATALOG" = T.CRN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.ROLEID in (select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UR I_USERROLES_AUTHID_FK)') || ' UR.ROLEID');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                      from USERROLES UR');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                     where UR.AUTHID = UTILIZER())');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                union all');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UP I_USERPRIV_CATALOG_AUTHID)') || ' null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 from USERPRIV UP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                where UP."CATALOG" = T.CRN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.AUTHID  = UTILIZER())');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and exists (select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UP I_USERPRIV_JUR_PERS_ROLEID)') || ' null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 from USERPRIV UP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                where UP.JUR_PERS = T.JUR_PERS');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.ROLEID in (select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UR I_USERROLES_AUTHID_FK)') || ' UR.ROLEID');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                      from USERROLES UR');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                     where UR.AUTHID = UTILIZER())');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                union all');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UP I_USERPRIV_JUR_PERS_AUTHID)') || ' null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 from USERPRIV UP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                where UP.JUR_PERS = T.JUR_PERS');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.AUTHID = UTILIZER())');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                %ORDER_BY%) D) F');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => ' where F.NROW between :NROW_FROM and :NROW_TO');
      /* Учтём сортировки */
      PKG_P8PANELS_VISUAL.TORDERS_SET_QUERY(RDATA_GRID => RDG, RORDERS => RO, SPATTERN => '%ORDER_BY%', CSQL => CSQL);
      /* Разбираем его */
      ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
      PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
      /* Делаем подстановку параметров */
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NCOMPANY', NVALUE => NCOMPANY);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NFCPRODPLANSP', NVALUE => NFCPRODPLANSP);
      /* Описываем структуру записи курсора */
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 1);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 2);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 3);
      PKG_SQL_DML.DEFINE_COLUMN_DATE(ICURSOR => ICURSOR, IPOSITION => 4);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 5);
      PKG_SQL_DML.DEFINE_COLUMN_DATE(ICURSOR => ICURSOR, IPOSITION => 6);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 7);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 8);
      /* Делаем выборку */
      if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
        null;
      end if;
      /* Обходим выбранные записи */
      while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
      loop
        /* Добавляем колонки с данными */
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NRN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 1,
                                              BCLEAR    => true);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SDOCPREF',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 2);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SDOCNUMB', ICURSOR => ICURSOR, NPOSITION => 3);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLD(RROW      => RDG_ROW,
                                              SNAME     => 'DEXEC_DATE',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 4);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NQUANT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 5);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLD(RROW      => RDG_ROW,
                                              SNAME     => 'DREL_DATE',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 6);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NREL_QUANT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 7);
        /* Добавляем строку в таблицу */
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
      end loop;
    exception
      when others then
        PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
        raise;
    end;
    /* Сериализуем описание */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  end FCROUTLST_DG_BY_PRDCT;

  /* Получение таблицы маршрутных листов, связанных со спецификацией плана (для приходов) */
  procedure FCROUTLST_DG_BY_DEPS
  (
    NFCPRODPLANSP           in number,                             -- Рег. номер связанной спецификации плана
    NPAGE_NUMBER            in number,                             -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- Количество записей на странице (0 - все)
    CORDERS                 in clob,                               -- Сортировки
    NINCLUDE_DEF            in number,                             -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob                               -- Сериализованная таблица данных
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    RO                      PKG_P8PANELS_VISUAL.TORDERS;           -- Сортировки
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- Описание таблицы
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы
    NROW_FROM               PKG_STD.TREF;                          -- Номер строки с
    NROW_TO                 PKG_STD.TREF;                          -- Номер строки по
    CSQL                    clob;                                  -- Буфер для запроса
    ICURSOR                 integer;                               -- Курсор для исполнения запроса
  begin
    /* Читем сортировки */
    RO := PKG_P8PANELS_VISUAL.TORDERS_FROM_XML(CORDERS => CORDERS);
    /* Преобразуем номер и размер страницы в номер строк с и по */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* Инициализируем таблицу данных */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE();
    /* Описываем колонки таблицы данных */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => 'Рег. номер',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SDOCPREF',
                                               SCAPTION   => 'Префикс',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SDOCNUMB',
                                               SCAPTION   => 'Номер',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DEXEC_DATE',
                                               SCAPTION   => 'Дата запуска',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NQUANT',
                                               SCAPTION   => 'Количество запуска',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DREL_DATE',
                                               SCAPTION   => 'Дата выпуска',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NREL_QUANT',
                                               SCAPTION   => 'Количество выпуска',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NQUANT_FACT',
                                               SCAPTION   => 'Сдано',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NPROCENT',
                                               SCAPTION   => '% готовности',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    /* Обходим данные */
    begin
      /* Добавляем подсказку совместимости */
      CSQL := PKG_SQL_BUILD.COMPATIBLE(SSQL => CSQL);
      /* Формируем запрос */
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => 'select *');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '  from (select D.*,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => PKG_SQL_BUILD.SQLROWNUM() || ' NROW');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '          from (select P.NRN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       P.SDOCPREF,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       P.SDOCNUMB,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       P.DEXEC_DATE,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       P.NQUANT,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       P.DREL_DATE,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       P.NREL_QUANT,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       P.NQUANT_FACT,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       case when (P.NT_SHT_PLAN <> 0) then ROUND(P.NLABOUR_FACT / P.NT_SHT_PLAN * 100, 3) else 0 end NPROCENT');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                  from (select T.RN        NRN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               T.DOCPREF   SDOCPREF,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               T.DOCNUMB   SDOCNUMB,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               T.EXEC_DATE DEXEC_DATE,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               T.QUANT     NQUANT,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               T.REL_DATE  DREL_DATE,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               T.REL_QUANT NREL_QUANT,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               (select SUM(SP.QUANT_FACT)');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  from DOCLINKS           D,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                       INCOMEFROMDEPSSPEC SP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 where D.IN_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                       and D.IN_DOCUMENT = T.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                       and D.OUT_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'IncomFromDeps'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                       and SP.PRN = D.OUT_DOCUMENT) NQUANT_FACT,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               (select SUM(SP.LABOUR_FACT)');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  from FCROUTLSTSP SP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 where SP.PRN = T.RN) NLABOUR_FACT,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               (select SUM(SP.T_SHT_PLAN)');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  from FCROUTLSTSP SP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 where SP.PRN = T.RN) NT_SHT_PLAN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                          from FCROUTLST T,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               DOCLINKS DL');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                         where DL.IN_DOCUMENT = :NFCPRODPLANSP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and DL.IN_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostProductPlansSpecs'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and DL.OUT_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and T.RN = DL.OUT_DOCUMENT');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and T.COMPANY = :NCOMPANY');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and T."STATE" = ' || PKG_SQL_BUILD.WRAP_NUM(NVALUE => 1));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and exists (select ' || PKG_SQL_BUILD.SET_HINT(SHINT =>  'INDEX(UP I_USERPRIV_CATALOG_ROLEID)') || ' null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                         from USERPRIV UP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        where UP."CATALOG" = T.CRN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                          and UP.ROLEID in (select ' || PKG_SQL_BUILD.SET_HINT(SHINT =>  'INDEX(UR I_USERROLES_AUTHID_FK)') || ' UR.ROLEID');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                              from USERROLES UR');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                             where UR.AUTHID = UTILIZER())');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        union all');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                       select ' || PKG_SQL_BUILD.SET_HINT(SHINT =>  'INDEX(UP I_USERPRIV_CATALOG_AUTHID)') || ' null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                         from USERPRIV UP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        where UP."CATALOG" = T.CRN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                          and UP.AUTHID  = UTILIZER())');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and exists (select ' || PKG_SQL_BUILD.SET_HINT(SHINT =>  'INDEX(UP I_USERPRIV_JUR_PERS_ROLEID)') || ' null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                         from USERPRIV UP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        where UP.JUR_PERS = T.JUR_PERS');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                          and UP.UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                          and UP.ROLEID in (select ' || PKG_SQL_BUILD.SET_HINT(SHINT =>  'INDEX(UR I_USERROLES_AUTHID_FK)') || ' UR.ROLEID');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                              from USERROLES UR');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                             where UR.AUTHID = UTILIZER())');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        union all');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                       select ' || PKG_SQL_BUILD.SET_HINT(SHINT =>  'INDEX(UP I_USERPRIV_JUR_PERS_AUTHID)') || ' null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                         from USERPRIV UP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        where UP.JUR_PERS = T.JUR_PERS');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                          and UP.UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                          and UP.AUTHID = UTILIZER())) P');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                %ORDER_BY%) D) F');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => ' where F.NROW between :NROW_FROM and :NROW_TO');
      /* Учтём сортировки */
      PKG_P8PANELS_VISUAL.TORDERS_SET_QUERY(RDATA_GRID => RDG, RORDERS => RO, SPATTERN => '%ORDER_BY%', CSQL => CSQL);
      /* Разбираем его */
      ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
      PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
      /* Делаем подстановку параметров */
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NCOMPANY', NVALUE => NCOMPANY);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NFCPRODPLANSP', NVALUE => NFCPRODPLANSP);
      /* Описываем структуру записи курсора */
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 1);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 2);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 3);
      PKG_SQL_DML.DEFINE_COLUMN_DATE(ICURSOR => ICURSOR, IPOSITION => 4);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 5);
      PKG_SQL_DML.DEFINE_COLUMN_DATE(ICURSOR => ICURSOR, IPOSITION => 6);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 7);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 8);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 9);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 10);
      /* Делаем выборку */
      if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
        null;
      end if;
      /* Обходим выбранные записи */
      while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
      loop
        /* Добавляем колонки с данными */
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NRN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 1,
                                              BCLEAR    => true);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SDOCPREF', ICURSOR => ICURSOR, NPOSITION => 2);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SDOCNUMB', ICURSOR => ICURSOR, NPOSITION => 3);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLD(RROW      => RDG_ROW,
                                              SNAME     => 'DEXEC_DATE',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 4);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW => RDG_ROW, SNAME => 'NQUANT', ICURSOR => ICURSOR, NPOSITION => 5);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLD(RROW      => RDG_ROW,
                                              SNAME     => 'DREL_DATE',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 6);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NREL_QUANT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 7);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NQUANT_FACT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 8);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW => RDG_ROW, SNAME => 'NPROCENT', ICURSOR => ICURSOR, NPOSITION => 9);
        /* Добавляем строку в таблицу */
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
      end loop;
    exception
      when others then
        PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
        raise;
    end;
    /* Сериализуем описание */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  end FCROUTLST_DG_BY_DEPS;

  /* Получение таблицы маршрутных листов, связанных со спецификацией плана с учетом типа */
  procedure FCROUTLST_DG_GET
  (
    NFCPRODPLANSP           in number,  -- Рег. номер связанной спецификации плана
    NTYPE                   in number,  -- Тип спецификации плана (см. константы NTASK_TYPE_*)
    NPAGE_NUMBER            in number,  -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,  -- Количество записей на странице (0 - все)
    CORDERS                 in clob,    -- Сортировки
    NINCLUDE_DEF            in number,  -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob    -- Сериализованная таблица данных
  )
  is
  begin
    /* Выбираем сборку таблицы, исходя из типа спецификации плана */
    case
      /* Деталь */
      when (NTYPE = NTASK_TYPE_RL_WITH_GP) then
        /* Получаем таблицу по детали */
        FCROUTLST_DG_BY_DTL(NFCPRODPLANSP => NFCPRODPLANSP,
                            NPAGE_NUMBER  => NPAGE_NUMBER,
                            NPAGE_SIZE    => NPAGE_SIZE,
                            CORDERS       => CORDERS,
                            NINCLUDE_DEF  => NINCLUDE_DEF,
                            COUT          => COUT);
      /* Изделие/сборочная единица */
      when (NTYPE = NTASK_TYPE_RL_WITH_DL) then
        /* Получаем таблицу по изделию */
        FCROUTLST_DG_BY_PRDCT(NFCPRODPLANSP => NFCPRODPLANSP,
                              NPAGE_NUMBER  => NPAGE_NUMBER,
                              NPAGE_SIZE    => NPAGE_SIZE,
                              CORDERS       => CORDERS,
                              NINCLUDE_DEF  => NINCLUDE_DEF,
                              COUT          => COUT);
      /* Для приходов из подразделений */
      when ((NTYPE = NTASK_TYPE_INC_DEPS_RL) or (NTYPE = NTASK_TYPE_RL)) then
        /* Получаем таблицу по приходу */
        FCROUTLST_DG_BY_DEPS(NFCPRODPLANSP => NFCPRODPLANSP,
                             NPAGE_NUMBER  => NPAGE_NUMBER,
                             NPAGE_SIZE    => NPAGE_SIZE,
                             CORDERS       => CORDERS,
                             NINCLUDE_DEF  => NINCLUDE_DEF,
                             COUT          => COUT);
      else
        P_EXCEPTION(0,
                    'Не определен тип получения таблицы маршрутных листов.');
    end case;
  end FCROUTLST_DG_GET;
  
  /* Получение списка спецификаций планов и отчетов производства изделий для диаграммы Ганта */
  procedure FCPRODPLANSP_GET
  (
    NCRN                    in number,                             -- Рег. номер каталога
    NLEVEL                  in number := null,                     -- Уровень отбора
    SSORT_FIELD             in varchar2 := 'DREP_DATE_TO',         -- Поле сортировки
    COUT                    out clob,                              -- Список задач
    NMAX_LEVEL              out number                             -- Максимальный уровень иерархии
  )
  is
    /* Переменные */
    RG                      PKG_P8PANELS_VISUAL.TGANTT;            -- Описание диаграммы Ганта
    RGT                     PKG_P8PANELS_VISUAL.TGANTT_TASK;       -- Описание задачи для диаграммы
    BREAD_ONLY_DATES        boolean := false;                      -- Флаг доступности дат проекта только для чтения
    STASK_BG_COLOR          PKG_STD.TSTRING;                       -- Цвет заливки задачи
    STASK_TEXT_COLOR        PKG_STD.TSTRING;                       -- Цвет текста задачи
    STASK_BG_PROGRESS_COLOR PKG_STD.TSTRING;                       -- Цвет заливки прогресса задачи
    NTASK_PROGRESS          PKG_STD.TNUMBER;                       -- Прогресс выполнения задачи
    DDATE_FROM              PKG_STD.TLDATE;                        -- Дата запуска спецификации
    DDATE_TO                PKG_STD.TLDATE;                        -- Дата выпуска спецификации
    STASK_CAPTION           PKG_STD.TSTRING;                       -- Описание задачи в Ганте
    NTYPE                   PKG_STD.TNUMBER;                       -- Тип задачи (см. константы NTASK_TYPE_*)
    SDETAIL_LIST            PKG_STD.TSTRING;                       -- Ссылки на детализацию
    SPLAN_TITLE             PKG_STD.TSTRING;                       -- Заголовок плана
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    NTASK_CLASS             PKG_STD.TNUMBER;                       -- Класс задачи (см. константы NCLASS_*)
    NLEVEL_FILTER           PKG_STD.TNUMBER;                       -- Уровень для фильтра

    /* Объединение значений в строковое представление */
    function MAKE_INFO
    (
      SPROD_ORDER           in varchar2,     -- Заказ
      SNOMEN_NAME           in varchar2,     -- Наименование номенклатуры
      SSUBDIV_DLVR          in varchar2,     -- Сдающее подразделение
      NMAIN_QUANT           in number        -- Выпуск
    ) return                varchar2         -- Описание задачи в Ганте
    is
      SRESULT               PKG_STD.TSTRING; -- Описание задачи в Ганте
    begin
      /* Соединяем информацию */
      SRESULT := STRCOMBINE(SPROD_ORDER, SNOMEN_NAME, ', ');
      SRESULT := STRCOMBINE(SRESULT, SSUBDIV_DLVR, ', ');
      SRESULT := STRCOMBINE(SRESULT, TO_CHAR(NMAIN_QUANT), ', ');
      /* Возвращаем результат */
      return SRESULT;
    end MAKE_INFO;

    /* Считывание максимального уровня иерархии плана по каталогу */
    function PRODPLAN_MAX_LEVEL_GET
    (
      NCRN                  in number             -- Рег. номер каталога планов
    ) return                number                -- Максимальный уровень иерархии
    is
      NRESULT               PKG_STD.TNUMBER := 1; -- Максимальный уровень иерархии
      NTOTAL                PKG_STD.TNUMBER := 0; -- Сумма документов по проверяемому уровню
    begin
      /* Цикл по уровням каталога планов */
      for REC in (select level,
                         count(TMP.RN) COUNT_DOCS
                    from (select T.RN,
                                 T.UP_LEVEL
                            from FCPRODPLAN   P,
                                 FCPRODPLANSP T,
                                 FINSTATE     FS
                           where P.CRN = NCRN
                             and P.CATEGORY = NFCPRODPLAN_CATEGORY
                             and P.STATUS = NFCPRODPLAN_STATUS
                             and FS.RN = P.TYPE
                             and FS.CODE = SFCPRODPLAN_TYPE
                             and exists (select /*+ INDEX(UP I_USERPRIV_JUR_PERS_ROLEID) */
                                   null
                                    from USERPRIV UP
                                   where UP.JUR_PERS = P.JUR_PERS
                                     and UP.UNITCODE = 'CostProductPlans'
                                     and UP.ROLEID in (select /*+ INDEX(UR I_USERROLES_AUTHID_FK) */
                                                        UR.ROLEID
                                                         from USERROLES UR
                                                        where UR.AUTHID = UTILIZER())
                                  union all
                                  select /*+ INDEX(UP I_USERPRIV_JUR_PERS_AUTHID) */
                                   null
                                    from USERPRIV UP
                                   where UP.JUR_PERS = P.JUR_PERS
                                     and UP.UNITCODE = 'CostProductPlans'
                                     and UP.AUTHID = UTILIZER())
                             and T.PRN = P.RN
                             and T.MAIN_QUANT > 0) TMP
                  connect by prior TMP.RN = TMP.UP_LEVEL
                   start with TMP.UP_LEVEL is null
                   group by level
                   order by level)
      loop
        /* Получаем количество задач с учетом текущего уровня */
        NTOTAL := NTOTAL + REC.COUNT_DOCS;
        /* Если сумма документов по текущему уровню превышает максимальное количество задач */
        if (NTOTAL >= NMAX_TASKS) then
          /* Выходим из цикла */
          exit;
        end if;
        /* Указываем текущий уровень */
        NRESULT := REC.LEVEL;
      end loop;
      /* Возвращаем результат */
      return NRESULT;
    end PRODPLAN_MAX_LEVEL_GET;
  
    /* Определение дат спецификации плана */
    procedure FCPRODPLANSP_DATES_GET
    (
      DREP_DATE             in date,    -- Дата запуска спецификации
      DREP_DATE_TO          in date,    -- Дата выпуска спецификации
      DINCL_DATE            in date,    -- Дата включения в план спецификации
      DDATE_FROM            out date,   -- Итоговая дата запуска спецификации
      DDATE_TO              out date    -- Итоговая дата выпуска спецификации
    )
    is
    begin
      /* Если даты запуска и выпуска пусты */
      if ((DREP_DATE is null) and (DREP_DATE_TO is null)) then
        /* Указываем дату включения в план */
        DDATE_FROM := DINCL_DATE;
        DDATE_TO   := DINCL_DATE;
      else
        /* Указываем даты исходя из дат запуска/выпуска */
        DDATE_FROM := COALESCE(DREP_DATE, DREP_DATE_TO);
        DDATE_TO   := COALESCE(DREP_DATE_TO, DREP_DATE);
      end if;
    end FCPRODPLANSP_DATES_GET;

    /* Инициализация динамических атрибутов */
    procedure TASK_ATTRS_INIT
    (
      RG                    in out nocopy PKG_P8PANELS_VISUAL.TGANTT -- Описание диаграммы Ганта
    )
    is
    begin
      /* Добавим динамические атрибуты к спецификациям */
      PKG_P8PANELS_VISUAL.TGANTT_ADD_TASK_ATTR(RGANTT   => RG,
                                               SNAME    => STASK_ATTR_START_FACT,
                                               SCAPTION => 'Запущено');
      PKG_P8PANELS_VISUAL.TGANTT_ADD_TASK_ATTR(RGANTT   => RG,
                                               SNAME    => STASK_ATTR_MAIN_QUANT,
                                               SCAPTION => 'Количество план');
      PKG_P8PANELS_VISUAL.TGANTT_ADD_TASK_ATTR(RGANTT   => RG,
                                               SNAME    => STASK_ATTR_REL_FACT,
                                               SCAPTION => 'Количество сдано');
      PKG_P8PANELS_VISUAL.TGANTT_ADD_TASK_ATTR(RGANTT   => RG,
                                               SNAME    => STASK_ATTR_REP_DATE_TO,
                                               SCAPTION => 'Дата выпуска план');
      PKG_P8PANELS_VISUAL.TGANTT_ADD_TASK_ATTR(RGANTT   => RG,
                                               SNAME    => STASK_ATTR_DL,
                                               SCAPTION => 'Анализ отклонений');
      PKG_P8PANELS_VISUAL.TGANTT_ADD_TASK_ATTR(RGANTT => RG, SNAME => STASK_ATTR_TYPE, SCAPTION => 'Тип');
      PKG_P8PANELS_VISUAL.TGANTT_ADD_TASK_ATTR(RGANTT   => RG,
                                               SNAME    => STASK_ATTR_MEAS,
                                               SCAPTION => 'Единица измерения');
    end TASK_ATTRS_INIT;

    /* Заполнение значений динамических атрибутов */
    procedure TASK_ATTRS_FILL
    (
      RG                    in PKG_P8PANELS_VISUAL.TGANTT,                 -- Описание диаграммы Ганта
      RGT                   in out nocopy PKG_P8PANELS_VISUAL.TGANTT_TASK, -- Описание задачи для диаграммы
      NSTART_FACT           in number,                                     -- Запуск факт
      NMAIN_QUANT           in number,                                     -- Выпуск
      NREL_FACT             in number,                                     -- Выпуск факт
      DREP_DATE_TO          in date,                                       -- Дата выпуска
      NTYPE                 in number,                                     -- Тип (см. константы NTASK_TYPE_*)
      SDETAIL_LIST          in varchar2,                                   -- Ссылки на детализацию
      SMEAS                 in varchar2                                    -- Единица измерения
    )
    is
    begin
      /* Добавим доп. атрибуты */
      PKG_P8PANELS_VISUAL.TGANTT_TASK_ADD_ATTR_VAL(RGANTT => RG,
                                                   RTASK  => RGT,
                                                   SNAME  => STASK_ATTR_START_FACT,
                                                   SVALUE => TO_CHAR(NSTART_FACT),
                                                   BCLEAR => true);
      PKG_P8PANELS_VISUAL.TGANTT_TASK_ADD_ATTR_VAL(RGANTT => RG,
                                                   RTASK  => RGT,
                                                   SNAME  => STASK_ATTR_MAIN_QUANT,
                                                   SVALUE => TO_CHAR(NMAIN_QUANT));
      PKG_P8PANELS_VISUAL.TGANTT_TASK_ADD_ATTR_VAL(RGANTT => RG,
                                                   RTASK  => RGT,
                                                   SNAME  => STASK_ATTR_REL_FACT,
                                                   SVALUE => TO_CHAR(NREL_FACT));
      PKG_P8PANELS_VISUAL.TGANTT_TASK_ADD_ATTR_VAL(RGANTT => RG,
                                                   RTASK  => RGT,
                                                   SNAME  => STASK_ATTR_REP_DATE_TO,
                                                   SVALUE => TO_CHAR(DREP_DATE_TO, 'dd.mm.yyyy hh24:mi'));
      PKG_P8PANELS_VISUAL.TGANTT_TASK_ADD_ATTR_VAL(RGANTT => RG,
                                                   RTASK  => RGT,
                                                   SNAME  => STASK_ATTR_TYPE,
                                                   SVALUE => TO_CHAR(NTYPE));
      PKG_P8PANELS_VISUAL.TGANTT_TASK_ADD_ATTR_VAL(RGANTT => RG,
                                                   RTASK  => RGT,
                                                   SNAME  => STASK_ATTR_DL,
                                                   SVALUE => SDETAIL_LIST);
      PKG_P8PANELS_VISUAL.TGANTT_TASK_ADD_ATTR_VAL(RGANTT => RG,
                                                   RTASK  => RGT,
                                                   SNAME  => STASK_ATTR_MEAS,
                                                   SVALUE => SMEAS);
    end TASK_ATTRS_FILL;

    /* Инициализация цветов */
    procedure TASK_COLORS_INIT
    (
      RG                    in out nocopy PKG_P8PANELS_VISUAL.TGANTT -- Описание диаграммы Ганта
    )
    is
    begin
      /* Добавим описание цветов */
      PKG_P8PANELS_VISUAL.TGANTT_ADD_TASK_COLOR(RGANTT    => RG,
                                                SBG_COLOR => SBG_COLOR_RED,
                                                SDESC     => 'Для спецификаций планов и отчетов производства изделий с «Дефицит запуска» != 0 или ' ||
                                                             'не имеющих связей с разделами «Маршрутный лист» или «Приход из подразделения», а также «Дата запуска» меньше текущей.');
      PKG_P8PANELS_VISUAL.TGANTT_ADD_TASK_COLOR(RGANTT    => RG,
                                                SBG_COLOR => SBG_COLOR_YELLOW,
                                                SDESC     => 'Для спецификаций планов и отчетов производства изделий с «Дефицит запуска» = 0 и «Выпуск факт» = 0.');
      PKG_P8PANELS_VISUAL.TGANTT_ADD_TASK_COLOR(RGANTT      => RG,
                                                SBG_COLOR   => SBG_COLOR_GREEN,
                                                STEXT_COLOR => STEXT_COLOR_GREY,
                                                SDESC       => 'Для спецификаций планов и отчетов производства изделий с «Дефицит выпуска» = 0.');
      PKG_P8PANELS_VISUAL.TGANTT_ADD_TASK_COLOR(RGANTT             => RG,
                                                SBG_COLOR          => SBG_COLOR_GREEN,
                                                SBG_PROGRESS_COLOR => SBG_COLOR_YELLOW,
                                                STEXT_COLOR        => STEXT_COLOR_GREY,
                                                SDESC              => 'Для спецификаций планов и отчетов производства изделий с «Дефицит запуска» = 0 и «Выпуск факт» != 0. ');
      PKG_P8PANELS_VISUAL.TGANTT_ADD_TASK_COLOR(RGANTT      => RG,
                                                SBG_COLOR   => SBG_COLOR_BLACK,
                                                STEXT_COLOR => STEXT_COLOR_ORANGE,
                                                SDESC       => 'Для спецификаций планов и отчетов производства изделий с пустыми «Дата запуска» и «Дата выпуска» и не имеющих связей с разделами «Маршрутный лист» или «Приход из подразделения».');
      PKG_P8PANELS_VISUAL.TGANTT_ADD_TASK_COLOR(RGANTT    => RG,
                                                SBG_COLOR => SBG_COLOR_GREY,
                                                SDESC     => 'Для спецификаций планов и отчетов производства изделий не имеющих связей с разделами «Маршрутный лист» или «Приход из подразделения», а также «Дата запуска» больше текущей.');
    end TASK_COLORS_INIT;

    /* Опеределение класса задачи */
    function GET_TASK_CLASS
    (
      NDEFRESLIZ            in number,       -- Дефицит запуска
      NREL_FACT             in number,       -- Выпуск факт
      NDEFSTART             in number,       -- Дефицит выпуска
      DREP_DATE             in date,         -- Дата запуска спецификации
      DREP_DATE_TO          in date,         -- Дата выпуска спецификации
      NHAVE_LINK            in number := 0   -- Наличие связей с "Маршрутный лист" или "Приход из подразделения"
    ) return                number           -- Класс задачи
    is
      NTASK_CLASS           PKG_STD.TNUMBER; -- Класс задачи (см. константы NCLASS*)
    begin
      /* Если одна из дат не указана */
      if ((DREP_DATE is null) or (DREP_DATE_TO is null)) then
        /* Если спецификация также не имеет связей */
        if (NHAVE_LINK = 0) then
          NTASK_CLASS := NCLASS_WO_LINKS;
        end if;
      else
        /* Если нет связанных документов */
        if (NHAVE_LINK = 0) then
          /* Если дата запуска меньше текущей даты */
          if (DREP_DATE <= sysdate) then
            NTASK_CLASS := NCLASS_WITH_DEFICIT;
          end if;
          /* Если дата больше текущей даты */
          if (DREP_DATE > sysdate) then
            NTASK_CLASS := NCLASS_FUTURE_DATE;
          end if;
        end if;
      end if;
      /* Если класс не определен */
      if (NTASK_CLASS is null) then
        /* Если дефицит запуска <> 0 */
        if (NDEFRESLIZ <> 0) then
          /* Если дефицит выпуска = 0 */
          if (NDEFSTART = 0) then
            NTASK_CLASS := NCLASS_WO_DEFICIT;
          else
            NTASK_CLASS := NCLASS_WITH_DEFICIT;
          end if;
        else
          /* Если дефицит выпуска = 0 */
          if (NDEFSTART = 0) then
            NTASK_CLASS := NCLASS_WO_DEFICIT;
          else
            /* Если дефицит запуска = 0 и выпуск факт = 0 */
            if ((NDEFRESLIZ = 0) and (NREL_FACT = 0)) then
              NTASK_CLASS := NCLASS_FULL_DEFICIT;
            end if;
            /* Если дефицит запуска = 0 и выпуск факт <> 0 */
            if ((NDEFRESLIZ = 0) and (NREL_FACT <> 0)) then
              NTASK_CLASS := NCLASS_PART_DEFICIT;
            end if;
          end if;
        end if;
      end if;
      /* Возвращаем результат */
      return NTASK_CLASS;
    end GET_TASK_CLASS;

    /* Получение типа задачи */
    procedure GET_TASK_TYPE
    (
      NCOMPANY              in number,   -- Рег. номер организации
      SSORT_FIELD           in varchar2, -- Тип сортировки
      NFCPRODPLAN           in number,   -- Рег. номер плана
      NFCPRODPLANSP         in number,   -- Рег. номер спецификации плана
      NTASK_CLASS           in number,   -- Класс задачи (см. константы NCLASS_*)
      NTYPE                 out number,  -- Тип задачи (см. константы NTASK_TYPE_*)
      SDETAIL_LIST          out varchar2 -- Ссылки на детализацию
    )
    is
    begin
      /* Исходим сортировка по "Дата запуска" */
      if (SSORT_FIELD = 'DREP_DATE') then
        /* Если класс "С дефицитом запуска или датой меньше текущей" */
        if (NTASK_CLASS = NCLASS_WITH_DEFICIT) then
          /* Проверяем деталь или изделие */
          begin
            select NTASK_TYPE_RL_WITH_DL
              into NTYPE
              from DUAL
             where exists (select null
                      from FCPRODPLANSP SP
                     where SP.PRN = NFCPRODPLAN
                       and SP.UP_LEVEL = NFCPRODPLANSP);
          exception
            when others then
              NTYPE := NTASK_TYPE_RL_WITH_GP;
          end;
          /* Проверяем наличие связей с маршрутными листами */
          if (LINK_FCROUTLST_CHECK(NCOMPANY => NCOMPANY, NFCPRODPLANSP => NFCPRODPLANSP, NSTATE => 0) = 0) then
            /* Указываем, что маршрутных листов нет */
            SDETAIL_LIST := 'Нет маршрутных листов';
            NTYPE        := NTASK_TYPE_EMPTY;
          else
            /* Указываем, что маршрутные листы есть */
            SDETAIL_LIST := 'Маршрутные листы';
          end if;
        else
          /* Не отображаем информацию о маршрутных листах */
          NTYPE        := NTASK_TYPE_EMPTY;
          SDETAIL_LIST := null;
        end if;
      else
        /* Исходим от класса */
        case
          /* Если класс "Без дефицита выпуска" */
          when (NTASK_CLASS = NCLASS_WO_DEFICIT) then
            /* Проверяем наличией связей с приходов из подразделений */
            if (LINK_INCOMEFROMDEPS_CHECK(NCOMPANY => NCOMPANY, NFCPRODPLANSP => NFCPRODPLANSP, NSTATE => 2) = 0) then
              /* Указываем, что приходов из подразделений нет */
              SDETAIL_LIST := 'Нет приходов из подразделений';
              NTYPE        := NTASK_TYPE_EMPTY;
            else
              /* Указываем, что приходы из подразделений есть */
              SDETAIL_LIST := 'Приход из подразделений';
              NTYPE        := NTASK_TYPE_INC_DEPS;
            end if;
          /* Если класс "С частичным дефицитом выпуска" */
          when (NTASK_CLASS = NCLASS_PART_DEFICIT) then
            /* Проверяем наличией связей с приходов из подразделений */
            if (LINK_INCOMEFROMDEPS_CHECK(NCOMPANY => NCOMPANY, NFCPRODPLANSP => NFCPRODPLANSP) = 0) then
              /* Указываем, что приходов из подразделений нет */
              SDETAIL_LIST := 'Нет приходов из подразделений';
              NTYPE        := NTASK_TYPE_EMPTY;
            else
              /* Указываем, что приходы из подразделений есть */
              SDETAIL_LIST := 'Приход из подразделений';
              NTYPE        := NTASK_TYPE_INC_DEPS_RL;
            end if;
          /* Если класс "С дефицитом запуска или датой меньше текущей" или "С полным дефицитом выпуска" */
          when ((NTASK_CLASS = NCLASS_FULL_DEFICIT) or (NTASK_CLASS = NCLASS_WITH_DEFICIT)) then
            /* Проверяем наличие связей с маршрутными листами */
            if (LINK_FCROUTLST_CHECK(NCOMPANY => NCOMPANY, NFCPRODPLANSP => NFCPRODPLANSP, NSTATE => 1) = 0) then
              /* Указываем, что маршрутных листов нет */
              SDETAIL_LIST := 'Нет маршрутных листов';
              NTYPE        := NTASK_TYPE_EMPTY;
            else
              /* Указываем, что маршрутные листы есть */
              SDETAIL_LIST := 'Маршрутные листы';
              NTYPE        := NTASK_TYPE_RL;
            end if;
          /* Класс не поддерживается */
          else
            /* Для данных классов ничего не выводится */
            NTYPE        := NTASK_TYPE_EMPTY;
            SDETAIL_LIST := null;
        end case;
      end if;
    end GET_TASK_TYPE;

    /* Формирование цветовых характеристик для задачи */
    procedure GET_TASK_COLORS
    (
      NTASK_CLASS             in number,      -- Класс задачи (см. константы NCLASS_*)
      STASK_BG_COLOR          out varchar2,   -- Цвет заливки спецификации
      STASK_BG_PROGRESS_COLOR out varchar2,   -- Цвет заливки прогресса спецификации
      STASK_TEXT_COLOR        in out varchar2 -- Цвет текста
    )
    is
    begin
      /* Исходим от класса задачи */
      case NTASK_CLASS
        /* Без дефицита выпуска */
        when NCLASS_WO_DEFICIT then
          STASK_BG_COLOR          := SBG_COLOR_GREEN;
          STASK_TEXT_COLOR        := STEXT_COLOR_GREY;
          STASK_BG_PROGRESS_COLOR := null;
        /* С частичным дефицитом выпуска */
        when NCLASS_PART_DEFICIT then
          STASK_BG_COLOR          := SBG_COLOR_GREEN;
          STASK_BG_PROGRESS_COLOR := SBG_COLOR_YELLOW;
          STASK_TEXT_COLOR        := STEXT_COLOR_GREY;
        /* С полным дефицитом выпуска */
        when NCLASS_FULL_DEFICIT then
          STASK_BG_COLOR          := SBG_COLOR_YELLOW;
          STASK_TEXT_COLOR        := null;
          STASK_BG_PROGRESS_COLOR := null;
        /* С дефицитом запуска или датой меньше текущей */
        when NCLASS_WITH_DEFICIT then
          STASK_BG_COLOR          := SBG_COLOR_RED;
          STASK_TEXT_COLOR        := null;
          STASK_BG_PROGRESS_COLOR := null;
        /* Дата анализа еще не наступила */
        when NCLASS_FUTURE_DATE then
          STASK_BG_COLOR   := SBG_COLOR_GREY;
          STASK_TEXT_COLOR := null;
          STASK_BG_PROGRESS_COLOR := null;
        /* Задача без связи */
        when NCLASS_WO_LINKS then
          STASK_BG_COLOR   := SBG_COLOR_BLACK;
          STASK_TEXT_COLOR := STEXT_COLOR_ORANGE;
          STASK_BG_PROGRESS_COLOR := null;
        else
          /* Не определено */
          STASK_BG_COLOR   := null;
          STASK_TEXT_COLOR := null;
          STASK_BG_PROGRESS_COLOR := null;
      end case;
    end GET_TASK_COLORS;
  begin
    /* Определяем заголовок плана */
    FIND_ACATALOG_RN(NFLAG_SMART => 0,
                     NCOMPANY    => NCOMPANY,
                     NVERSION    => null,
                     SUNITCODE   => 'CostProductPlans',
                     NRN         => NCRN,
                     SNAME       => SPLAN_TITLE);
    /* Инициализируем диаграмму Ганта */
    RG := PKG_P8PANELS_VISUAL.TGANTT_MAKE(STITLE              => SPLAN_TITLE,
                                          NZOOM               => PKG_P8PANELS_VISUAL.NGANTT_ZOOM_DAY,
                                          BREAD_ONLY_DATES    => BREAD_ONLY_DATES,
                                          BREAD_ONLY_PROGRESS => true);
    /* Инициализируем динамические атрибуты к спецификациям */
    TASK_ATTRS_INIT(RG => RG);
    /* Инициализируем описания цветов */
    TASK_COLORS_INIT(RG => RG);
    /* Определяем максимальный уровень иерархии */
    NMAX_LEVEL := PRODPLAN_MAX_LEVEL_GET(NCRN => NCRN);
    /* Определяем уровень фильтра */
    NLEVEL_FILTER := COALESCE(NLEVEL, NMAX_LEVEL);
    /* Обходим данные */
    for C in (select TMP.*,
                     level NTASK_LEVEL
                from (select T.RN NRN,
                             T.PRN NPRN,
                             (select PORD.NUMB from FACEACC PORD where PORD.RN = T.PROD_ORDER) SPROD_ORDER,
                             T.REP_DATE DREP_DATE,
                             T.REP_DATE_TO DREP_DATE_TO,
                             T.INCL_DATE DINCL_DATE,
                             T.ROUTE SROUTE,
                             (FM.CODE || ', ' || FM.NAME) SNAME,
                             D.NOMEN_NAME SNOMEN_NAME,
                             T.START_FACT NSTART_FACT,
                             (T.QUANT_REST - T.START_FACT) NDEFRESLIZ,
                             T.REL_FACT NREL_FACT,
                             (T.MAIN_QUANT - T.REL_FACT) NDEFSTART,
                             T.MAIN_QUANT NMAIN_QUANT,
                             (select IDD.CODE from INS_DEPARTMENT IDD where IDD.RN = T.SUBDIV_DLVR) SSUBDIV_DLVR,
                             (select 1
                                from DUAL
                               where exists (select null
                                        from DOCLINKS L
                                       where L.IN_DOCUMENT = T.RN
                                         and L.IN_UNITCODE = 'CostProductPlansSpecs'
                                         and (L.OUT_UNITCODE = 'CostRouteLists' or L.OUT_UNITCODE = 'IncomFromDeps')
                                         and ROWNUM = 1)) NHAVE_LINK,
                             T.UP_LEVEL NUP_LEVEL,
                             case SSORT_FIELD
                               when 'DREP_DATE_TO' then
                                T.REP_DATE_TO
                               else
                                T.REP_DATE
                             end DORDER_DATE,
                             DM.MEAS_MNEMO SMEAS
                        from FCPRODPLAN    P,
                             FINSTATE      FS,
                             FCPRODPLANSP  T,
                             FCMATRESOURCE FM,
                             DICNOMNS      D,
                             DICMUNTS      DM
                       where P.CRN = NCRN
                         and P.CATEGORY = NFCPRODPLAN_CATEGORY
                         and P.STATUS = NFCPRODPLAN_STATUS
                         and FS.RN = P.TYPE
                         and FS.CODE = SFCPRODPLAN_TYPE
                         and exists
                       (select /*+ INDEX(UP I_USERPRIV_JUR_PERS_ROLEID) */
                               null
                                from USERPRIV UP
                               where UP.JUR_PERS = P.JUR_PERS
                                 and UP.UNITCODE = 'CostProductPlans'
                                 and UP.ROLEID in (select /*+ INDEX(UR I_USERROLES_AUTHID_FK) */
                                                    UR.ROLEID
                                                     from USERROLES UR
                                                    where UR.AUTHID = UTILIZER())
                              union all
                              select /*+ INDEX(UP I_USERPRIV_JUR_PERS_AUTHID) */
                               null
                                from USERPRIV UP
                               where UP.JUR_PERS = P.JUR_PERS
                                 and UP.UNITCODE = 'CostProductPlans'
                                 and UP.AUTHID = UTILIZER())
                         and T.PRN = P.RN
                         and T.MAIN_QUANT > 0
                         and ((T.REP_DATE is not null) or (T.REP_DATE_TO is not null) or (T.INCL_DATE is not null))
                         and FM.RN = T.MATRES
                         and D.RN = FM.NOMENCLATURE
                         and D.UMEAS_MAIN = DM.RN) TMP
               where level <= NLEVEL_FILTER
              connect by prior TMP.NRN = TMP.NUP_LEVEL
               start with TMP.NUP_LEVEL is null
               order siblings by TMP.DORDER_DATE asc)
    loop
      /* Формируем описание задачи в Ганте */
      STASK_CAPTION := MAKE_INFO(SPROD_ORDER  => C.SPROD_ORDER,
                                 SNOMEN_NAME  => C.SNOMEN_NAME,
                                 SSUBDIV_DLVR => C.SSUBDIV_DLVR,
                                 NMAIN_QUANT  => C.NMAIN_QUANT);
      /* Определяем класс задачи */
      NTASK_CLASS := GET_TASK_CLASS(NDEFRESLIZ   => C.NDEFRESLIZ,
                                    NREL_FACT    => C.NREL_FACT,
                                    NDEFSTART    => C.NDEFSTART,
                                    DREP_DATE    => C.DREP_DATE,
                                    DREP_DATE_TO => C.DREP_DATE_TO,
                                    NHAVE_LINK   => COALESCE(C.NHAVE_LINK, 0));
      /* Инициализируем даты и цвет (если необходимо) */
      FCPRODPLANSP_DATES_GET(DREP_DATE    => C.DREP_DATE,
                             DREP_DATE_TO => C.DREP_DATE_TO,
                             DINCL_DATE   => C.DINCL_DATE,
                             DDATE_FROM   => DDATE_FROM,
                             DDATE_TO     => DDATE_TO);
      /* Формирование характеристик элемента ганта */
      GET_TASK_COLORS(NTASK_CLASS             => NTASK_CLASS,
                      STASK_BG_COLOR          => STASK_BG_COLOR,
                      STASK_BG_PROGRESS_COLOR => STASK_BG_PROGRESS_COLOR,
                      STASK_TEXT_COLOR        => STASK_TEXT_COLOR);
      /* Если класс задачи "С частичным дефицитом выпуска" */
      if (NTASK_CLASS = NCLASS_PART_DEFICIT) then
        /* Определяем пропорции прогресса */
        NTASK_PROGRESS := ROUND(C.NREL_FACT / C.NMAIN_QUANT * 100);
      else
        /* Не требуется */
        NTASK_PROGRESS := null;
      end if;
      /* Сформируем основную спецификацию */
      RGT := PKG_P8PANELS_VISUAL.TGANTT_TASK_MAKE(NRN                 => C.NRN,
                                                  SNUMB               => COALESCE(C.SROUTE, 'Отсутствует'),
                                                  SCAPTION            => STASK_CAPTION,
                                                  SNAME               => C.SNAME,
                                                  DSTART              => DDATE_FROM,
                                                  DEND                => DDATE_TO,
                                                  NPROGRESS           => NTASK_PROGRESS,
                                                  SBG_COLOR           => STASK_BG_COLOR,
                                                  STEXT_COLOR         => STASK_TEXT_COLOR,
                                                  SBG_PROGRESS_COLOR  => STASK_BG_PROGRESS_COLOR,
                                                  BREAD_ONLY          => true,
                                                  BREAD_ONLY_DATES    => true,
                                                  BREAD_ONLY_PROGRESS => true);
      /* Определяем тип и ссылки на детализацию */
      GET_TASK_TYPE(NCOMPANY      => NCOMPANY,
                    SSORT_FIELD   => SSORT_FIELD,
                    NFCPRODPLAN   => C.NPRN,
                    NFCPRODPLANSP => C.NRN,
                    NTASK_CLASS   => NTASK_CLASS,
                    NTYPE         => NTYPE,
                    SDETAIL_LIST  => SDETAIL_LIST);
      /* Заполним значение динамических атрибутов */
      TASK_ATTRS_FILL(RG           => RG,
                      RGT          => RGT,
                      NSTART_FACT  => C.NSTART_FACT,
                      NMAIN_QUANT  => C.NMAIN_QUANT,
                      NREL_FACT    => C.NREL_FACT,
                      DREP_DATE_TO => C.DREP_DATE_TO,
                      NTYPE        => NTYPE,
                      SDETAIL_LIST => SDETAIL_LIST,
                      SMEAS        => C.SMEAS);
      /* Собираем зависимости */
      for LINK in (select T.RN
                     from FCPRODPLANSP T
                    where T.PRN = C.NPRN
                      and T.UP_LEVEL = C.NRN
                      and T.MAIN_QUANT > 0
                      and NLEVEL_FILTER >= C.NTASK_LEVEL + 1)
      loop
        /* Добавляем зависимости */
        PKG_P8PANELS_VISUAL.TGANTT_TASK_ADD_DEPENDENCY(RTASK => RGT, NDEPENDENCY => LINK.RN);
      end loop;
      /* Добавляем основную спецификацию в диаграмму */
      PKG_P8PANELS_VISUAL.TGANTT_ADD_TASK(RGANTT => RG, RTASK => RGT);
    end loop;
    /* Формируем список */
    COUT := PKG_P8PANELS_VISUAL.TGANTT_TO_XML(RGANTT => RG);
  end FCPRODPLANSP_GET;

  /* Инициализация каталогов раздела "Планы и отчеты производства изделий" для панели "Производственная программа" */
  procedure FCPRODPLAN_PP_CTLG_INIT
  (
    COUT                    out clob    -- Список каталогов раздела "Планы и отчеты производства изделий"
  )
  is
  begin
    /* Начинаем формирование XML */
    PKG_XFAST.PROLOGUE(ITYPE => PKG_XFAST.CONTENT_);
    /* Открываем корень */
    PKG_XFAST.DOWN_NODE(SNAME => 'XDATA');
    /* Цикл по планам и отчетам производства изделий */
    for REC in (select T.RN as NRN,
                       T.NAME as SNAME,
                       (select count(P.RN)
                          from FCPRODPLAN P,
                               FINSTATE   FS
                         where P.CRN = T.RN
                           and P.CATEGORY = NFCPRODPLAN_CATEGORY
                           and P.STATUS = NFCPRODPLAN_STATUS
                           and P.COMPANY = GET_SESSION_COMPANY()
                           and FS.RN = P.TYPE
                           and FS.CODE = SFCPRODPLAN_TYPE
                           and exists (select PSP.RN
                                  from FCPRODPLANSP PSP
                                 where PSP.PRN = P.RN
                                   and PSP.MAIN_QUANT > 0)
                           and exists (select /*+ INDEX(UP I_USERPRIV_JUR_PERS_ROLEID) */
                                 null
                                  from USERPRIV UP
                                 where UP.JUR_PERS = P.JUR_PERS
                                   and UP.UNITCODE = 'CostProductPlans'
                                   and UP.ROLEID in (select /*+ INDEX(UR I_USERROLES_AUTHID_FK) */
                                                      UR.ROLEID
                                                       from USERROLES UR
                                                      where UR.AUTHID = UTILIZER())
                                union all
                                select /*+ INDEX(UP I_USERPRIV_JUR_PERS_AUTHID) */
                                 null
                                  from USERPRIV UP
                                 where UP.JUR_PERS = P.JUR_PERS
                                   and UP.UNITCODE = 'CostProductPlans'
                                   and UP.AUTHID = UTILIZER())) as NCOUNT_DOCS
                  from ACATALOG T,
                       UNITLIST UL
                 where T.DOCNAME = 'CostProductPlans'
                   and T.SIGNS = 1
                   and T.DOCNAME = UL.UNITCODE
                   and T.COMPANY = GET_SESSION_COMPANY()
                   and (UL.SHOW_INACCESS_CTLG = 1 or exists
                        (select null from V_USERPRIV UP where UP.CATALOG = T.RN) or exists
                        (select null
                           from ACATALOG T1
                          where exists (select null from V_USERPRIV UP where UP.CATALOG = T1.RN)
                         connect by prior T1.RN = T1.CRN
                          start with T1.CRN = T.RN))
                 order by T.NAME asc)
    loop
      /* Открываем план */
      PKG_XFAST.DOWN_NODE(SNAME => 'XFCPRODPLAN_CRNS');
      /* Описываем план */
      PKG_XFAST.ATTR(SNAME => 'NRN', NVALUE => REC.NRN);
      PKG_XFAST.ATTR(SNAME => 'SNAME', SVALUE => REC.SNAME);
      PKG_XFAST.ATTR(SNAME => 'NCOUNT_DOCS', NVALUE => REC.NCOUNT_DOCS);
      /* Закрываем план */
      PKG_XFAST.UP();
    end loop;
    /* Закрываем корень */
    PKG_XFAST.UP();
    /* Сериализуем */
    COUT := PKG_XFAST.SERIALIZE_TO_CLOB();
    /* Завершаем формирование XML */
    PKG_XFAST.EPILOGUE();
  exception
    when others then
      /* Завершаем формирование XML */
      PKG_XFAST.EPILOGUE();
      /* Вернем ошибку */
      PKG_STATE.DIAGNOSTICS_STACKED();
      P_EXCEPTION(0, PKG_STATE.SQL_ERRM());
  end FCPRODPLAN_PP_CTLG_INIT;
  
  /*
    Процедуры панели "Производственный план цеха"
  */
  
  /* Изменение приоритета партии маршрутного листа */
  procedure FCROUTLST_PRIOR_PARTY_UPDATE
  (
    NFCROUTLST              in number,         -- Рег. номер маршрутного листа
    SPRIOR_PARTY            in varchar         -- Новое значение приоритета партии
  )
  is
    RFCROUTLST              FCROUTLST%rowtype; -- Запись маршрутного листа
  begin
    /* Проверяем нет ли лишних символов */
    if ((SPRIOR_PARTY is not null) and (REGEXP_COUNT(SPRIOR_PARTY, '[^0123456789]+') > 0)) then
      P_EXCEPTION(0, 'Значение приоритета должно быть целым числом.');
    end if;
    /* Считываем запись маршрутного листа */
    UTL_FCROUTLST_GET(NFCROUTLST => NFCROUTLST, RFCROUTLST => RFCROUTLST);
    /* Исправляем приоритет партии */
    RFCROUTLST.PRIOR_PARTY := TO_NUMBER(SPRIOR_PARTY);
    /* Базовое исправление маршрутного листа */
    P_FCROUTLST_BASE_UPDATE(NRN            => RFCROUTLST.RN,
                            NCOMPANY       => RFCROUTLST.COMPANY,
                            NDOCTYPE       => RFCROUTLST.DOCTYPE,
                            SDOCPREF       => RFCROUTLST.DOCPREF,
                            SDOCNUMB       => RFCROUTLST.DOCNUMB,
                            DDOCDATE       => RFCROUTLST.DOCDATE,
                            SBARCODE       => RFCROUTLST.BARCODE,
                            NJUR_PERS      => RFCROUTLST.JUR_PERS,
                            NSTATE         => RFCROUTLST.STATE,
                            DCHANGE_DATE   => RFCROUTLST.CHANGE_DATE,
                            NFACEACC       => RFCROUTLST.FACEACC,
                            NPR_COND       => RFCROUTLST.PR_COND,
                            NMATRES        => RFCROUTLST.MATRES,
                            NNOMCLASSIF    => RFCROUTLST.NOMCLASSIF,
                            NARTICLE       => RFCROUTLST.ARTICLE,
                            NQUANT         => RFCROUTLST.QUANT,
                            NMATRES_PLAN   => RFCROUTLST.MATRES_PLAN,
                            NMEASURE_TYPE  => RFCROUTLST.MEASURE_TYPE,
                            NQUANT_PLAN    => RFCROUTLST.QUANT_PLAN,
                            NMATRES_FACT   => RFCROUTLST.MATRES_FACT,
                            NQUANT_FACT    => RFCROUTLST.QUANT_FACT,
                            DOUT_DATE      => RFCROUTLST.OUT_DATE,
                            NBLANK         => RFCROUTLST.BLANK,
                            NDETAILS_COUNT => RFCROUTLST.DETAILS_COUNT,
                            NSUPPLY        => RFCROUTLST.SUPPLY,
                            NSTORAGE       => RFCROUTLST.STORAGE,
                            NSTORAGE_IN    => RFCROUTLST.STORAGE_IN,
                            NPRODCMP       => RFCROUTLST.PRODCMP,
                            NPRODCMPSP     => RFCROUTLST.PRODCMPSP,
                            DREL_DATE      => RFCROUTLST.REL_DATE,
                            NREL_QUANT     => RFCROUTLST.REL_QUANT,
                            NPRIOR_ORDER   => RFCROUTLST.PRIOR_ORDER,
                            NPRIOR_PARTY   => RFCROUTLST.PRIOR_PARTY,
                            NROUTSHT       => RFCROUTLST.ROUTSHT,
                            NROUTE         => RFCROUTLST.ROUTE,
                            NCALC_SCHEME   => RFCROUTLST.CALC_SCHEME,
                            NPER_MATRES    => RFCROUTLST.PER_MATRES,
                            NCOST_ARTICLE  => RFCROUTLST.COST_ARTICLE,
                            NVALID_DOCTYPE => RFCROUTLST.VALID_DOCTYPE,
                            SVALID_DOCNUMB => RFCROUTLST.VALID_DOCNUMB,
                            DVALID_DOCDATE => RFCROUTLST.VALID_DOCDATE,
                            SNOTE          => RFCROUTLST.NOTE,
                            NPARTY         => RFCROUTLST.PARTY,
                            DEXEC_DATE     => RFCROUTLST.EXEC_DATE,
                            SSEP_NUMB      => RFCROUTLST.SEP_NUMB,
                            SINT_NUMB      => RFCROUTLST.INT_NUMB);
  end FCROUTLST_PRIOR_PARTY_UPDATE;
  
  /* Получение таблицы маршрутных листов, связанных со спецификацией плана */
  procedure FCROUTLST_DEPT_DG_GET
  (
    NFCPRODPLANSP           in number,                             -- Рег. номер связанной спецификации плана
    NPAGE_NUMBER            in number,                             -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- Количество записей на странице (0 - все)
    CORDERS                 in clob,                               -- Сортировки
    NINCLUDE_DEF            in number,                             -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob                               -- Сериализованная таблица данных
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    RO                      PKG_P8PANELS_VISUAL.TORDERS;           -- Сортировки
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- Описание таблицы
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы
    NROW_FROM               PKG_STD.TREF;                          -- Номер строки с
    NROW_TO                 PKG_STD.TREF;                          -- Номер строки по
    CSQL                    clob;                                  -- Буфер для запроса
    ICURSOR                 integer;                               -- Курсор для исполнения запроса
    NFCROUTLST_IDENT        PKG_STD.TREF;                          -- Рег. номер идентификатора отмеченных записей маршрутных листов
    NFCMATRESOURCE          PKG_STD.TREF;                          -- Рег. номер материального ресурса записи спецификации плана
    NFCROUTLST              PKG_STD.TREF;                          -- Рег. номер связанного маршрутного листа
    NFCPRODPLANSP_MAIN      PKG_STD.TREF;                          -- Рег. номер основного состава из "Производственная программа"
    NFCROUTLSTORD_QUANT     PKG_STD.TLNUMBER;                      -- Сумма "Количество" в спецификации "Заказы" маршрутного листа
    
    /* Считывание материального ресурса спецификации плана */
    function MATRES_RN_GET
    (
      NFCPRODPLANSP         in number     -- Рег. номер спецификации плана
    ) return                number        -- Рег. номер материального ресурса
    is
      NRESULT               PKG_STD.TREF; -- Рег. номер материального ресурса
    begin
      /* Считываем рег. номер материального ресурса */
      begin
        select T.MATRES into NRESULT from FCPRODPLANSP T where T.RN = NFCPRODPLANSP;
      exception
        when others then
          P_EXCEPTION(0,
                      'Ошибка считывания материального ресурса спецификации плана.');
      end;
      /* Возвращаем результат */
      return NRESULT;
    end MATRES_RN_GET;
    
    /* Проверка прямой связи между МЛ и спецификацией плана "Заказы" */
    function FCROUTLSTORD_QUANT_GET
    (
      NFCROUTLST            in number         -- Рег. номер маршрутного листа
    ) return                number            -- Сумма "Количество" в спецификации "Заказы"
    is
      NRESULT               PKG_STD.TLNUMBER; -- Сумма "Количество" в спецификации "Заказы"
    begin
      /* Считываем сумму "Количество" из спецификации "Заказы" */
      begin
        select COALESCE(sum(T.QUANT), 0) into NRESULT from FCROUTLSTORD T where T.PRN = NFCROUTLST;
      exception
        when others then
          NRESULT := 0;
      end;
      /* Возвращаем результат */
      return NRESULT;
    end FCROUTLSTORD_QUANT_GET;
  begin
    /* Читем сортировки */
    RO := PKG_P8PANELS_VISUAL.TORDERS_FROM_XML(CORDERS => CORDERS);
    /* Преобразуем номер и размер страницы в номер строк с и по */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* Инициализируем таблицу данных */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE();
    /* Описываем колонки таблицы данных */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => 'Рег. номер',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SDOC_INFO',
                                               SCAPTION   => 'Документ (тип, №, дата)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NQUANT',
                                               SCAPTION   => 'Количество план',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NPROCENT',
                                               SCAPTION   => 'Готовность партии',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NPRIOR_PARTY',
                                               SCAPTION   => 'Приоритет партии',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SPROD_ORDER',
                                               SCAPTION   => 'Заказ',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    /*! Пока отключен */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NCHANGE_FACEACC',
                                               SCAPTION   => 'Изменить заказ',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false,
                                               BORDER     => true);
    /* Считываем рег. номер связанной спецификации из "Производственная программа" */
    NFCPRODPLANSP_MAIN := UTL_FCPRODPLANSP_MAIN_GET(NCOMPANY => NCOMPANY, NFCPRODPLANSP => NFCPRODPLANSP);
    /* Если спецификация производственной программы найдена */
    if (NFCPRODPLANSP_MAIN is not null) then
      /* Считывание материального ресурса спецификации плана */
      NFCMATRESOURCE := MATRES_RN_GET(NFCPRODPLANSP => NFCPRODPLANSP_MAIN);
      /* Инициализируем список маршрутных листов */
      UTL_FCROUTLST_IDENT_INIT(NFCPRODPLANSP => NFCPRODPLANSP_MAIN, NIDENT => NFCROUTLST_IDENT);
      /* Обходим данные */
      begin
        /* Добавляем подсказку совместимости */
        CSQL := PKG_SQL_BUILD.COMPATIBLE(SSQL => CSQL);
        /* Формируем запрос */
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => 'select *');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '  from (select D.*,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => PKG_SQL_BUILD.SQLROWNUM() || ' NROW');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '          from (select P.NRN,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       P.SDOC_INFO,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       P.NQUANT,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       case when (P.NT_SHT_PLAN <> 0) then P.NLABOUR_FACT / P.NT_SHT_PLAN * 100 else 0 end NPROCENT,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       P.NPRIOR_PARTY,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       P.SPROD_ORDER');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                  from (select T.RN           NRN,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               DT.DOCCODE ||');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               '', '' || TRIM(T.DOCPREF) ||');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               ''-'' || TRIM(T.DOCNUMB) ||');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               '', '' || TO_CHAR(T.DOCDATE, ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'dd.mm.yyyy') || ') as SDOC_INFO,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               T.QUANT        NQUANT,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               (select SUM(SP.LABOUR_FACT)');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  from FCROUTLSTSP SP');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 where SP.PRN = T.RN) NLABOUR_FACT,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               (select SUM(SP.T_SHT_PLAN)');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  from FCROUTLSTSP SP');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 where SP.PRN = T.RN) NT_SHT_PLAN,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               T.PRIOR_PARTY  NPRIOR_PARTY,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               (select F.NUMB from FACEACC F where T.FACEACC = F.RN ) SPROD_ORDER');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                          from FCROUTLST T,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               DOCTYPES DT');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                         where T.RN in (select SL."DOCUMENT"');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                          from SELECTLIST SL');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                         where SL.IDENT = :NFCROUTLST_IDENT');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                           and SL.UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists') || ')');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and T.COMPANY = :NCOMPANY');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and T."STATE" = ' || PKG_SQL_BUILD.WRAP_NUM(NVALUE => 1));
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and T.MATRES = :NFCMATRESOURCE');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and DT.RN = T.DOCTYPE');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and exists (select ' || PKG_SQL_BUILD.SET_HINT(SHINT =>  'INDEX(UP I_USERPRIV_CATALOG_ROLEID)') || ' null');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                         from USERPRIV UP');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        where UP."CATALOG" = T.CRN');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                          and UP.ROLEID in (select ' || PKG_SQL_BUILD.SET_HINT(SHINT =>  'INDEX(UR I_USERROLES_AUTHID_FK)') || ' UR.ROLEID'); 
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                              from USERROLES UR');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                             where UR.AUTHID = UTILIZER())');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        union all');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                       select ' || PKG_SQL_BUILD.SET_HINT(SHINT =>  'INDEX(UP I_USERPRIV_CATALOG_AUTHID)') || ' null');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                         from USERPRIV UP');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        where UP."CATALOG" = T.CRN');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                          and UP.AUTHID  = UTILIZER())');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and exists (select ' || PKG_SQL_BUILD.SET_HINT(SHINT =>  'INDEX(UP I_USERPRIV_JUR_PERS_ROLEID)') || ' null');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                         from USERPRIV UP');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        where UP.JUR_PERS = T.JUR_PERS');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                          and UP.UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists'));
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                          and UP.ROLEID in (select ' || PKG_SQL_BUILD.SET_HINT(SHINT =>  'INDEX(UR I_USERROLES_AUTHID_FK)') || ' UR.ROLEID'); 
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                              from USERROLES UR');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                             where UR.AUTHID = UTILIZER())');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        union all');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                       select ' || PKG_SQL_BUILD.SET_HINT(SHINT =>  'INDEX(UP I_USERPRIV_JUR_PERS_AUTHID)') || ' null');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                         from USERPRIV UP');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        where UP.JUR_PERS = T.JUR_PERS');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                          and UP.UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists'));
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                          and UP.AUTHID = UTILIZER())) P');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                %ORDER_BY%) D) F');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => ' where F.NROW between :NROW_FROM and :NROW_TO');
        /* Учтём сортировки */
        PKG_P8PANELS_VISUAL.TORDERS_SET_QUERY(RDATA_GRID => RDG, RORDERS => RO, SPATTERN => '%ORDER_BY%', CSQL => CSQL);
        /* Разбираем его */
        ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
        PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
        /* Делаем подстановку параметров */
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NCOMPANY', NVALUE => NCOMPANY);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NFCROUTLST_IDENT', NVALUE => NFCROUTLST_IDENT);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NFCMATRESOURCE', NVALUE => NFCMATRESOURCE);
        /* Описываем структуру записи курсора */
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 1);
        PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 2);
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 3);
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 4);
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 5);
        PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 6);
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 7);
        /* Делаем выборку */
        if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
          null;
        end if;
        /* Обходим выбранные записи */
        while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
        loop
          /* Читаем данные из курсора */
          PKG_SQL_DML.COLUMN_VALUE_NUM(ICURSOR => ICURSOR, IPOSITION => 1, NVALUE => NFCROUTLST);
          /* Добавляем колонку с рег. номером */
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NRN', NVALUE => NFCROUTLST, BCLEAR => true);
          /* Добавляем колонки с данными */
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                                SNAME     => 'NRN',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 1,
                                                BCLEAR    => true);
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                                SNAME     => 'SDOC_INFO',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 2);
          /* Проверяем наличие прямой связи между МЛ и спецификацией плана */
          if (PKG_DOCLINKS.FIND(NFLAG_SMART       => 1,
                                SIN_UNITCODE      => 'CostProductPlansSpecs',
                                NIN_DOCUMENT      => NFCPRODPLANSP_MAIN,
                                NIN_PRN_DOCUMENT  => null,
                                SOUT_UNITCODE     => 'CostRouteLists',
                                NOUT_DOCUMENT     => NFCROUTLST,
                                NOUT_PRN_DOCUMENT => null) = 1) then
            /* Получаем сумму "Количество" из спецификации "Заказы" */
            NFCROUTLSTORD_QUANT := FCROUTLSTORD_QUANT_GET(NFCROUTLST => NFCROUTLST);
            /* Если сумма "Количество" в "Заказы" больше 0 */
            if (NFCROUTLSTORD_QUANT > 0) then
              /* Указываем её */
              PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NQUANT', NVALUE => NFCROUTLSTORD_QUANT);
            else
              /* Берем из заголовка МЛ */
              PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                                    SNAME     => 'NQUANT',
                                                    ICURSOR   => ICURSOR,
                                                    NPOSITION => 3);
            end if;
          else
            /* Указываем 0 */
            PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NQUANT', NVALUE => 0);
          end if;
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW => RDG_ROW, SNAME => 'NPROCENT', ICURSOR => ICURSOR, NPOSITION => 4);
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                                SNAME     => 'NPRIOR_PARTY',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 5);
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                                SNAME     => 'SPROD_ORDER',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 6);
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NCHANGE_FACEACC', SVALUE => null);
          /* Добавляем строку в таблицу */
          PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
        end loop;
      exception
        when others then
          PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
          raise;
      end;
      /* Очищаем отмеченные маршрутные листы */
      P_SELECTLIST_CLEAR(NIDENT => NFCROUTLST_IDENT);
    end if;
    /* Сериализуем описание */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  exception
    when others then
      /* Очищаем отмеченные маршрутные листы */
      P_SELECTLIST_CLEAR(NIDENT => NFCROUTLST_IDENT);
      raise;
  end FCROUTLST_DEPT_DG_GET;
  
  /* Получение таблицы строк маршрутного листа */
  procedure FCROUTLSTSP_DEPT_DG_GET
  (
    NFCROUTLST              in number,                             -- Рег. номер маршрутного листа
    NPAGE_NUMBER            in number,                             -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- Количество записей на странице (0 - все)
    CORDERS                 in clob,                               -- Сортировки
    NINCLUDE_DEF            in number,                             -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob                               -- Сериализованная таблица данных
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    RO                      PKG_P8PANELS_VISUAL.TORDERS;           -- Сортировки
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- Описание таблицы
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы
    NROW_FROM               PKG_STD.TREF;                          -- Номер строки с
    NROW_TO                 PKG_STD.TREF;                          -- Номер строки по
    CSQL                    clob;                                  -- Буфер для запроса
    ICURSOR                 integer;                               -- Курсор для исполнения запроса
    NSTATE                  PKG_STD.TNUMBER;                       -- Состояние
    
    /* Считывание текстового представления состояния строки маршрутного листа */
    function FCROUTLSTSP_STATE_NAME_GET
    (
      NSTATE                in number        -- Состояние строки маршрутного листа
    ) return                varchar2         -- Наименование состояния строки маршрутного листа
    is
      SRESULT               PKG_STD.TSTRING; -- Наименование состояния строки маршрутного листа
    begin
      /* Считываем наименование состояния по домену */
      begin
        select V.NAME
          into SRESULT
          from DMSDOMAINS    T,
               DMSENUMVALUES V
         where T.CODE = SFCROUTLSTSP_STATE_DOMAIN
           and V.PRN = T.RN
           and V.VALUE_NUM = NSTATE;
      exception
        when others then
          SRESULT := null;
      end;
      /* Возвращаем результат */
      return SRESULT;
    end FCROUTLSTSP_STATE_NAME_GET;
  begin
    /* Читем сортировки */
    RO := PKG_P8PANELS_VISUAL.TORDERS_FROM_XML(CORDERS => CORDERS);
    /* Преобразуем номер и размер страницы в номер строк с и по */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* Инициализируем таблицу данных */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE();
    /* Описываем колонки таблицы данных */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => 'Рег. номер',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SSTATE',
                                               SCAPTION   => 'Состояние',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SOPER_NUMB',
                                               SCAPTION   => 'Номер операции',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SROUTSHTSP_NAME',
                                               SCAPTION   => 'Операция',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SSUBDIV',
                                               SCAPTION   => 'Цех, участок',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NQUANT_PLAN',
                                               SCAPTION   => 'План',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NQUANT_FACT',
                                               SCAPTION   => 'Факт',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NT_SHT_PLAN',
                                               SCAPTION   => 'Трудоемкость план',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NLABOUR_FACT',
                                               SCAPTION   => 'Трудоемкость факт',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SMUNIT',
                                               SCAPTION   => 'ЕИ трудоемкости',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true);
    /* Обходим данные */
    begin
      /* Добавляем подсказку совместимости */
      CSQL := PKG_SQL_BUILD.COMPATIBLE(SSQL => CSQL);
      /* Формируем запрос */
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => 'select *');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '  from (select D.*,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => PKG_SQL_BUILD.SQLROWNUM() || ' NROW');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '          from (select T.RN          NRN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T."STATE"     NSTATE,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.OPER_NUMB   SOPER_NUMB,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       trim(T.OPER_NUMB) || '', '' || ');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       trim(COALESCE(( select O."NAME" from FCOPERTYPES O where T.OPER_TPS = O.RN ), T.OPER_UK)) SROUTSHTSP_NAME,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       ( select I.CODE from INS_DEPARTMENT I where T.SUBDIV = I.RN ) SSUBDIV,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.QUANT_PLAN NQUANT_PLAN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.QUANT_FACT NQUANT_FACT,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.T_SHT_PLAN NT_SHT_PLAN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.LABOUR_FACT NLABOUR_FACT,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       ( select D.MEAS_MNEMO from DICMUNTS D where T.MUNIT = D.RN ) SMUNIT');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                  from FCROUTLSTSP T');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                 where T.PRN = :NFCROUTLST');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.COMPANY = :NCOMPANY');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                %ORDER_BY%) D) F');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => ' where F.NROW between :NROW_FROM and :NROW_TO');
      /* Учтём сортировки */
      PKG_P8PANELS_VISUAL.TORDERS_SET_QUERY(RDATA_GRID => RDG, RORDERS => RO, SPATTERN => '%ORDER_BY%', CSQL => CSQL);
      /* Разбираем его */
      ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
      PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
      /* Делаем подстановку параметров */
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NCOMPANY', NVALUE => NCOMPANY);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NFCROUTLST', NVALUE => NFCROUTLST);
      /* Описываем структуру записи курсора */
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 1);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 2);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 3);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 4);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 5);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 6);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 7);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 8);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 9);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 10);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 11);
      /* Делаем выборку */
      if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
        null;
      end if;
      /* Обходим выбранные записи */
      while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
      loop
        /* Добавляем колонки с данными */
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NRN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 1,
                                              BCLEAR    => true);
        /* Читаем состояние из курсора */
        PKG_SQL_DML.COLUMN_VALUE_NUM(ICURSOR => ICURSOR, IPOSITION => 2, NVALUE => NSTATE);
        PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW   => RDG_ROW,
                                         SNAME  => 'SSTATE',
                                         SVALUE => FCROUTLSTSP_STATE_NAME_GET(NSTATE => NSTATE));
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SOPER_NUMB',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 3);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SROUTSHTSP_NAME',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 4);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SSUBDIV', ICURSOR => ICURSOR, NPOSITION => 5);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NQUANT_PLAN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 6);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NQUANT_FACT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 7);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NT_SHT_PLAN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 8);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NLABOUR_FACT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 9);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SMUNIT', ICURSOR => ICURSOR, NPOSITION => 10);
        /* Добавляем строку в таблицу */
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
      end loop;
    exception
      when others then
        PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
        raise;
    end;
    /* Сериализуем описание */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  end FCROUTLSTSP_DEPT_DG_GET;
  
  /* Получение таблицы ПиП на основании маршрутного листа, связанных со спецификацией плана */
  procedure INCOMEFROMDEPS_DEPT_DG_GET
  (
    NFCPRODPLANSP           in number,                             -- Рег. номер связанной спецификации плана
    NPAGE_NUMBER            in number,                             -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- Количество записей на странице (0 - все)
    CORDERS                 in clob,                               -- Сортировки
    NINCLUDE_DEF            in number,                             -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob                               -- Сериализованная таблица данных
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    RO                      PKG_P8PANELS_VISUAL.TORDERS;           -- Сортировки
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- Описание таблицы
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы
    NROW_FROM               PKG_STD.TREF;                          -- Номер строки с
    NROW_TO                 PKG_STD.TREF;                          -- Номер строки по
    CSQL                    clob;                                  -- Буфер для запроса
    ICURSOR                 integer;                               -- Курсор для исполнения запроса
    NFCPRODPLANSP_MAIN      PKG_STD.TREF;                          -- Рег. номер основного состава из "Производственная программа"
    NFCROUTLST_IDENT        PKG_STD.TREF;                          -- Рег. номер идентификатора отмеченных записей маршрутных листов
  begin
    /* Читем сортировки */
    RO := PKG_P8PANELS_VISUAL.TORDERS_FROM_XML(CORDERS => CORDERS);
    /* Преобразуем номер и размер страницы в номер строк с и по */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* Инициализируем таблицу данных */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE();
    /* Описываем колонки таблицы данных */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => 'Рег. номер',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SSTATE',
                                               SCAPTION   => 'Состояние',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SDOC_INFO',
                                               SCAPTION   => 'Документ (тип, №, дата)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NQUANT_FACT',
                                               SCAPTION   => 'Количество сдано',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DDUE_DATE',
                                               SCAPTION   => 'Дата сдачи',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               BVISIBLE   => true,
                                               BORDER     => true);
    /* Считываем рег. номер связанной спецификации из "Производственная программа" */
    NFCPRODPLANSP_MAIN := UTL_FCPRODPLANSP_MAIN_GET(NCOMPANY => NCOMPANY, NFCPRODPLANSP => NFCPRODPLANSP);
    /* Если спецификация производственной программы найдена */
    if (NFCPRODPLANSP_MAIN is not null) then
      /* Инициализируем список маршрутных листов */
      UTL_FCROUTLST_IDENT_INIT(NFCPRODPLANSP => NFCPRODPLANSP_MAIN, NIDENT => NFCROUTLST_IDENT);
      /* Обходим данные */
      begin
        /* Добавляем подсказку совместимости */
        CSQL := PKG_SQL_BUILD.COMPATIBLE(SSQL => CSQL);
        /* Формируем запрос */
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => 'select *');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '  from (select D.*,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => PKG_SQL_BUILD.SQLROWNUM() || ' NROW');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '          from (select T.RN NRN,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       SUBSTR(F_DOCSTATE_PLAN_FACT(T.DOC_STATE), 1, 20) SSTATE,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       DT.DOCCODE ||');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       '', '' || TRIM(T.DOC_PREF) ||');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       ''-'' || TRIM(T.DOC_NUMB) ||');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       '', '' || TO_CHAR(T.DOC_DATE, ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'dd.mm.yyyy') || ') as SDOC_INFO,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       (select SUM(SP.QUANT_FACT)');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                          from INCOMEFROMDEPSSPEC SP');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                         where SP.PRN = T.RN) NQUANT_FACT,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                        T.WORK_DATE as DDUE_DATE');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                  from INCOMEFROMDEPS T,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       DOCTYPES DT');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                 where ((T.RN in (select L.OUT_DOCUMENT');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                    from DOCLINKS L');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                   where L.IN_DOCUMENT = :NFCPRODPLANSP');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                     and L.IN_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostProductPlansSpecs'));
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                     and L.OUT_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'IncomFromDeps') || '))');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                        or (T.RN in (select L.OUT_DOCUMENT');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                       from SELECTLIST SL,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                            DOCLINKS   L');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                      where SL.IDENT       = :NFCROUTLST_IDENT');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        and SL.UNITCODE    = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists'));
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        and L.IN_DOCUMENT  = SL."DOCUMENT"');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        and L.IN_UNITCODE  = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists'));
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                        and L.OUT_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'IncomFromDeps') || ')))');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.COMPANY = :NCOMPANY');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.DOC_TYPE = DT.RN');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                %ORDER_BY%) D) F');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => ' where F.NROW between :NROW_FROM and :NROW_TO');
        /* Учтём сортировки */
        PKG_P8PANELS_VISUAL.TORDERS_SET_QUERY(RDATA_GRID => RDG, RORDERS => RO, SPATTERN => '%ORDER_BY%', CSQL => CSQL);
        /* Разбираем его */
        ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
        PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
        /* Делаем подстановку параметров */
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NCOMPANY', NVALUE => NCOMPANY);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NFCPRODPLANSP', NVALUE => NFCPRODPLANSP_MAIN);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NFCROUTLST_IDENT', NVALUE => NFCROUTLST_IDENT);
        /* Описываем структуру записи курсора */
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 1);
        PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 2);
        PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 3);
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 4);
        PKG_SQL_DML.DEFINE_COLUMN_DATE(ICURSOR => ICURSOR, IPOSITION => 5);
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 6);
        /* Делаем выборку */
        if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
          null;
        end if;
        /* Обходим выбранные записи */
        while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
        loop
          /* Добавляем колонки с данными */
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                                SNAME     => 'NRN',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 1,
                                                BCLEAR    => true);
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                                SNAME     => 'SSTATE',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 2);
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                                SNAME     => 'SDOC_INFO',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 3);
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                                SNAME     => 'NQUANT_FACT',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 4);
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLD(RROW      => RDG_ROW,
                                                SNAME     => 'DDUE_DATE',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 5);
          /* Добавляем строку в таблицу */
          PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
        end loop;
      exception
        when others then
          PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
          raise;
      end;
      /* Очищаем отмеченные маршрутные листы */
      P_SELECTLIST_CLEAR(NIDENT => NFCROUTLST_IDENT);
    end if;
    /* Сериализуем описание */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  exception
    when others then
      /* Очищаем отмеченные маршрутные листы */
      P_SELECTLIST_CLEAR(NIDENT => NFCROUTLST_IDENT);
      raise;
  end INCOMEFROMDEPS_DEPT_DG_GET;
  
  /* Получение таблицы спецификаций планов и отчетов производства изделий */
  procedure FCPRODPLANSP_DEPT_DG_GET
  (
    NFCPRODPLAN             in number,                             -- Рег. номер планов и отчетов производства изделий
    NPAGE_NUMBER            in number,                             -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- Количество записей на странице (0 - все)
    CORDERS                 in clob,                               -- Сортировки
    NINCLUDE_DEF            in number,                             -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob                               -- Сериализованная таблица данных
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    RO                      PKG_P8PANELS_VISUAL.TORDERS;           -- Сортировки
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- Описание таблицы
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы
    NROW_FROM               PKG_STD.TREF;                          -- Номер строки с
    NROW_TO                 PKG_STD.TREF;                          -- Номер строки по
    CSQL                    clob;                                  -- Буфер для запроса
    ICURSOR                 integer;                               -- Курсор для исполнения запроса
    NFCPRODPLANSP           PKG_STD.TREF;                          -- Рег. номер спецификации плана
    DDATE                   PKG_STD.TLDATE := sysdate;             -- Текущая дата
    NSUM_PLAN               PKG_STD.TLNUMBER;                      -- Сумма плана по строке
    NSUM_FACT               PKG_STD.TLNUMBER;                      -- Сумма факта по строке
    DDATE_FROM              PKG_STD.TLDATE;                        -- Дата начала месяца
    DDATE_TO                PKG_STD.TLDATE;                        -- Дата окончания месяца
    NFCROUTLST_IDENT        PKG_STD.TREF;                          -- Рег. номер идентификатора отмеченных записей маршрутных листов
    NFCPRODPLANSP_MAIN      PKG_STD.TREF;                          -- Рег. номер основного состава из "Производственная программа"
    NMODIF                  PKG_STD.TREF;                          -- Рег. номер модификации
    
    /* Считывание номенклатуры по спецификации плана */
    function FCPRODPLANSP_MODIF_GET
    (
      NFCPRODPLANSP         in number     -- Рег. номер связанной спецификации плана
    ) return                number        -- Рег. номер модификации номенклатуры
    is
      NRESULT               PKG_STD.TREF; -- Рег. номер модификации номенклатуры
    begin
      /* Считываем рег. номер модификации спецификации плана */
      begin
        select F.NOMEN_MODIF
          into NRESULT
          from FCPRODPLANSP  T,
               FCMATRESOURCE F
         where T.RN = NFCPRODPLANSP
           and F.RN = T.MATRES;
      exception
        when others then
          NRESULT := null;
      end;
      /* Возвращаем результат */
      return NRESULT;
    end FCPRODPLANSP_MODIF_GET;
    
    /* Инициализация дней месяца */
    procedure INIT_DAYS
    (
      RDG                   in out nocopy PKG_P8PANELS_VISUAL.TDATA_GRID, -- Описание таблицы
      DDATE_FROM            in date,                                      -- Дата начала месяца
      DDATE_TO              in date                                       -- Дата окончания месяца
    )
    is
      DDATE                 PKG_STD.TLDATE;                               -- Сформированная дата дня
      NMONTH                PKG_STD.TNUMBER;                              -- Текущий месяц
      NYEAR                 PKG_STD.TNUMBER;                              -- Текущий год
      SDATE_NAME            PKG_STD.TSTRING;                              -- Строковое представление даты для наименования колонки
      SPARENT_NAME          PKG_STD.TSTRING;                              -- Наименование родительской строки
    begin
      /* Считываем месяц и год текущей даты */
      NMONTH := D_MONTH(DDATE => sysdate);
      NYEAR  := D_YEAR(DDATE => sysdate);
      /* Цикл по дням месяца */
      for I in D_DAY(DDATE => DDATE_FROM) .. D_DAY(DDATE => DDATE_TO)
      loop
        /* Формируем дату дня */
        DDATE := TO_DATE(TO_CHAR(I) || '.' || TO_CHAR(NMONTH) || '.' || TO_CHAR(NYEAR), 'dd.mm.yyyy');
        /* Строковое представление даты для наименования колонки */
        SDATE_NAME := TO_CHAR(DDATE, SCOL_PATTERN_DATE);
        /* Формируем наименование родительской строки */
        SPARENT_NAME := 'N_' || SDATE_NAME || '_PLAN_FACT';
        /* Описываем родительскую колонку таблицы данных */
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                                   SNAME      => SPARENT_NAME,
                                                   SCAPTION   => LPAD(D_DAY(DDATE), 2, '0'),
                                                   SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                                   SPARENT    => 'NVALUE_BY_DAYS');
      end loop;
    end INIT_DAYS;
    
    /* Расчет факта выпусков плана */
    procedure FCPRODPLANSP_CALC
    (
      NFCPRODPLAN           in number,    -- Рег. номер планов и отчетов производства изделий
      NCOMPANY              in number     -- Рег. номер организации
    )
    is
      NIDENT                PKG_STD.TREF; -- Идентификатор отмеченных записей
      NTMP                  PKG_STD.TREF; -- Буфер
    begin
      /* Генерируем идентификатор отмеченных записей */
      NIDENT := GEN_IDENT();
      /* Цикл по записям спецификации плана */
      for REC in (select T.RN from FCPRODPLANSP T where T.PRN = NFCPRODPLAN)
      loop
        /* Добавляем запись в отмеченные записи */
        P_SELECTLIST_INSERT(NIDENT => NIDENT, NDOCUMENT => REC.RN, SUNITCODE => 'CostProductPlansSpecs', NRN => NTMP);
      end loop;
      /* Расчет факта */
      P_FCPRODPLANSP_BASE_CALC_FACT(NCOMPANY => NCOMPANY, NIDENT => NIDENT);
      /* Очистка отмеченных записей */
      P_SELECTLIST_CLEAR(NIDENT => NIDENT);
    exception
      when others then
        /* Очистка отмеченных записей */
        P_SELECTLIST_CLEAR(NIDENT => NIDENT);
    end FCPRODPLANSP_CALC;
  begin
    /* Если это выбор плана */
    if (NINCLUDE_DEF = 1) then
      /* Расчет факта выпусков плана */
      FCPRODPLANSP_CALC(NFCPRODPLAN => NFCPRODPLAN, NCOMPANY => NCOMPANY);
    end if;
    /* Читем сортировки */
    RO := PKG_P8PANELS_VISUAL.TORDERS_FROM_XML(CORDERS => CORDERS);
    /* Преобразуем номер и размер страницы в номер строк с и по */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* Инициализируем таблицу данных */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE(BFIXED_HEADER => true, NFIXED_COLUMNS => 7);
    /* Описываем колонки таблицы данных */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => 'Рег. номер',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SSTATUS',
                                               SCAPTION   => 'Статус',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SPROD_ORDER',
                                               SCAPTION   => 'Заказ',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true,
                                               SHINT      => 'Содержит ссылку на связанные сдаточные накладные.',
                                               NWIDTH     => 100);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SMATRES_CODE',
                                               SCAPTION   => 'Обозначение',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true,
                                               SHINT      => 'Содержит ссылку на связанные маршрутные листы.<br><br>' ||
                                                             'Цвет залики отражает следующие статусы:<br>' ||
                                                             '<b style="color:lightgreen">Зеленый</b> - "Факт" равен "План";<br>' ||
                                                             '<b style="color:lightblue">Голубой</b> - "План" меньше или равно "Факт" + "Запущено";<br>' ||
                                                             '<b style="color:#F0E68C">Желтый</b> - предыдущие условия не выполнены и на текущую дату сумма "Количество план" = 0 или меньше "План", то "Факт" больше или равно "План". ' ||
                                                             'Иначе сумма "Количество факт" больше или равно сумме "Количество план";<br>' ||
                                                             '<b style="color:lightcoral">Красный</b> - ни одно из предыдущих условий не выполнено.<br>',
                                               NWIDTH     => 120);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SMATRES_NAME',
                                               SCAPTION   => 'Наименование',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true,
                                               NWIDTH     => 200);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SSUBDIV',
                                               SCAPTION   => 'Цех-получатель',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true,
                                               BORDER     => true,
                                               NWIDTH     => 180);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NMAIN_QUANT',
                                               SCAPTION   => 'План',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               NWIDTH     => 80);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NREL_FACT',
                                               SCAPTION   => 'Факт',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               NWIDTH     => 80);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NFCROUTLST_QUANT',
                                               SCAPTION   => 'Запущено',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               NWIDTH     => 90);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NVALUE_BY_DAYS',
                                               SCAPTION   => 'План/факт по дням',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true,
                                               SHINT      => 'Значения по спецификации "График сдачи":<br>' ||
                                                             'Черный - значение "Количество план";<br>' ||
                                                             '<b style="color:blue">Синий</b> - значение "Количество факт".<br><br>' ||
                                                             'Заливка <b style="color:lightgrey">серым</b> определяет текущий день.');
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NSUM_PLAN',
                                               SCAPTION   => 'Сумма "Количество план"',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NSUM_FACT',
                                               SCAPTION   => 'Сумма "Количество факт"',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    /* Считываем первый и последний день месяца */
    P_FIRST_LAST_DAY(DCALCDATE => sysdate, DBGNDATE => DDATE_FROM, DENDDATE => DDATE_TO);
    /* Инициализация дней месяца */
    INIT_DAYS(RDG => RDG, DDATE_FROM => DDATE_FROM, DDATE_TO => DDATE_TO);
    /* Обходим данные */
    begin
      /* Добавляем подсказку совместимости */
      CSQL := PKG_SQL_BUILD.COMPATIBLE(SSQL => CSQL);
      /* Формируем запрос */
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => 'select *');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '  from (select D.*,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => PKG_SQL_BUILD.SQLROWNUM() || ' NROW');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '          from (select T.RN NRN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       (select PORD.NUMB from FACEACC PORD where (PORD.RN = T.PROD_ORDER)) SPROD_ORDER,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       MRES.CODE SMATRES_CODE,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       MRES."NAME" SMATRES_NAME,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       (select INS_D.CODE from INS_DEPARTMENT INS_D where INS_D.RN = T.SUBDIV) SSUBDIV,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.MAIN_QUANT NMAIN_QUANT,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.REL_FACT NREL_FACT,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       (select COALESCE(sum(F.QUANT), ' || PKG_SQL_BUILD.WRAP_NUM(NVALUE => 0) || ')');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                          from DOCLINKS  DL,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               DOCLINKS  L,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               FCROUTLST F');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                         where DL.OUT_DOCUMENT = T.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and DL.IN_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostProductPlansSpecs'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and DL.OUT_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostProductPlansSpecs'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and L.IN_DOCUMENT = DL.IN_DOCUMENT');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and L.IN_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostProductPlansSpecs'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and L.OUT_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and F.RN = L.OUT_DOCUMENT');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and F."STATE" = ' || PKG_SQL_BUILD.WRAP_NUM(NVALUE => 1) || ') NFCROUTLST_QUANT');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                  from FCPRODPLAN    P,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       FCPRODPLANSP  T,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       FCMATRESOURCE MRES');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                 where P.RN = :NFCPRODPLAN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and P.COMPANY = :NCOMPANY');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.PRN = P.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.MAIN_QUANT <> ' || PKG_SQL_BUILD.WRAP_NUM(NVALUE => 0));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.MATRES = MRES.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and exists (select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UP I_USERPRIV_CATALOG_ROLEID)') || ' null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 from USERPRIV UP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                where UP."CATALOG" = T.CRN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.ROLEID in (select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UR I_USERROLES_AUTHID_FK)') || ' UR.ROLEID');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                      from USERROLES UR');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                     where UR.AUTHID = UTILIZER())');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                union all');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UP I_USERPRIV_CATALOG_AUTHID)') || ' null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 from USERPRIV UP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                where UP."CATALOG" = T.CRN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.AUTHID = UTILIZER())');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and exists (select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UP I_USERPRIV_JUR_PERS_ROLEID)') || ' null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 from USERPRIV UP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                where UP.JUR_PERS = T.JUR_PERS');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostProductPlans'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.ROLEID in (select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UR I_USERROLES_AUTHID_FK)') || ' UR.ROLEID');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                      from USERROLES UR');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                     where UR.AUTHID = UTILIZER())');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                union all');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(UP I_USERPRIV_JUR_PERS_AUTHID)') || ' null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 from USERPRIV UP');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                where UP.JUR_PERS = T.JUR_PERS');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostProductPlans'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and UP.AUTHID = UTILIZER())');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                 %ORDER_BY%) D) F');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => ' where F.NROW between :NROW_FROM and :NROW_TO');
      /* Учтём сортировки */
      PKG_P8PANELS_VISUAL.TORDERS_SET_QUERY(RDATA_GRID => RDG, RORDERS => RO, SPATTERN => '%ORDER_BY%', CSQL => CSQL);
      /* Разбираем его */
      ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
      PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
      /* Делаем подстановку параметров */
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NCOMPANY', NVALUE => NCOMPANY);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NFCPRODPLAN', NVALUE => NFCPRODPLAN);
      /* Описываем структуру записи курсора */
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 1);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 2);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 3);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 4);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 5);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 6);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 7);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 8);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 9);
      /* Делаем выборку */
      if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
        null;
      end if;
      /* Обходим выбранные записи */
      while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
      loop
        /* Читаем данные из курсора */
        PKG_SQL_DML.COLUMN_VALUE_NUM(ICURSOR => ICURSOR, IPOSITION => 1, NVALUE => NFCPRODPLANSP);
        /* Добавляем колонку с рег. номером */
        PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NRN', NVALUE => NFCPRODPLANSP, BCLEAR => true);
        /* Добавляем колонки с данными */
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SPROD_ORDER',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 2);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SMATRES_CODE',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 3);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SMATRES_NAME',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 4);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SSUBDIV', ICURSOR => ICURSOR, NPOSITION => 5);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NMAIN_QUANT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 6);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NREL_FACT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 7);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NFCROUTLST_QUANT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 8);
        /* Считываем рег. номер связанной спецификации из "Производственная программа" */
        NFCPRODPLANSP_MAIN := UTL_FCPRODPLANSP_MAIN_GET(NCOMPANY => NCOMPANY, NFCPRODPLANSP => NFCPRODPLANSP);
        /* Если есть связанная спецификация из производственной программы */
        if (NFCPRODPLANSP_MAIN is not null) then
          /* Инициализируем список маршрутных листов */
          UTL_FCROUTLST_IDENT_INIT(NFCPRODPLANSP => NFCPRODPLANSP_MAIN, NIDENT => NFCROUTLST_IDENT);
          /* Считываем модификацию номенклатуры */
          NMODIF := FCPRODPLANSP_MODIF_GET(NFCPRODPLANSP => NFCPRODPLANSP_MAIN);
        end if;
        /* Обнуляем сумму "Количество план" и "Количество факт" по строке */
        NSUM_PLAN := 0;
        NSUM_FACT := 0;
        /* Добавляем значения по графику сдачи */
        for REC in (select TMP.DOC_DATE,
                           COALESCE(sum(TMP.QUANT_PLAN), 0) QUANT_PLAN,
                           COALESCE(sum(TMP.QUANT_FACT), 0) QUANT_FACT
                      from ( /* Указаны в спецификации */
                            select T.DOC_DATE,
                                    T.QUANT_PLAN,
                                    0 QUANT_FACT
                              from FCPRODPLANDLVSH T
                             where T.PRN = NFCPRODPLANSP
                               and T.DOC_DATE >= DDATE_FROM
                               and T.DOC_DATE <= DDATE_TO
                            union
                            /* Связаны со спецификацией плана или связанной строкой "Производственная программа" */
                            select D.WORK_DATE,
                                    0,
                                    sum(S.QUANT_FACT)
                              from INCOMEFROMDEPS     D,
                                    INCOMEFROMDEPSSPEC S
                             where ( /* Связь по МЛ связанной строки "Производственная программа" */
                                    (D.RN in (select DL.OUT_DOCUMENT
                                                from SELECTLIST SL,
                                                     FCROUTLST  FL,
                                                     DOCLINKS   DL
                                               where SL.IDENT = NFCROUTLST_IDENT
                                                 and SL.UNITCODE = 'CostRouteLists'
                                                 and FL.RN = SL.DOCUMENT
                                                 and FL.STATE = 1
                                                 and DL.IN_DOCUMENT = FL.RN
                                                 and DL.IN_UNITCODE = 'CostRouteLists'
                                                 and DL.OUT_UNITCODE = 'IncomFromDeps')) or
                                   /* Прямая связь со связанной строкой "Производственная программа" */
                                    (D.RN in (select L.OUT_DOCUMENT
                                                from DOCLINKS L
                                               where L.IN_DOCUMENT = NFCPRODPLANSP_MAIN
                                                 and L.IN_UNITCODE = 'CostProductPlansSpecs'
                                                 and L.OUT_UNITCODE = 'IncomFromDeps')) or
                                   /* Прямая связь с обрабатываемой строкой */
                                    (D.RN in (select L.OUT_DOCUMENT
                                                from DOCLINKS L
                                               where L.IN_DOCUMENT = NFCPRODPLANSP
                                                 and L.IN_UNITCODE = 'CostProductPlansSpecs'
                                                 and L.OUT_UNITCODE = 'IncomFromDeps')))
                               and D.DOC_STATE = NFCPRODPLAN_STATUS
                               and D.WORK_DATE >= DDATE_FROM
                               and D.WORK_DATE <= DDATE_TO
                               and S.PRN = D.RN
                               and S.NOMMODIF = NMODIF
                             group by D.WORK_DATE) TMP
                     group by TMP.DOC_DATE)
        loop
          /* Добавляем значение план/факт в соответствующую колонку */
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW   => RDG_ROW,
                                           SNAME  => 'N_' || TO_CHAR(REC.DOC_DATE, SCOL_PATTERN_DATE) || '_PLAN_FACT',
                                           SVALUE => TO_CHAR(REC.QUANT_PLAN) || '/' || TO_CHAR(REC.QUANT_FACT));
          /* Если это ранее текущей даты */
          if (REC.DOC_DATE <= DDATE) then
            /* Добавляем к сумме по строке */
            NSUM_PLAN := NSUM_PLAN + REC.QUANT_PLAN;
            NSUM_FACT := NSUM_FACT + REC.QUANT_FACT;
          end if;
        end loop;
        /* Добавляем колонки с суммами */
        PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NSUM_PLAN', NVALUE => NSUM_PLAN);
        PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NSUM_FACT', NVALUE => NSUM_FACT);
        /* Добавляем строку в таблицу */
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
        /* Очищаем отмеченные маршрутные листы */
        P_SELECTLIST_CLEAR(NIDENT => NFCROUTLST_IDENT);
      end loop;
    exception
      when others then
        PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
        /* Очищаем отмеченные маршрутные листы */
        P_SELECTLIST_CLEAR(NIDENT => NFCROUTLST_IDENT);
        raise;
    end;
    /* Сериализуем описание */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  end FCPRODPLANSP_DEPT_DG_GET;
  
  /* Инициализация записей раздела "Планы и отчеты производства изделий" */
  procedure FCPRODPLAN_DEPT_INIT
  (
    COUT                    out clob                               -- Список записей раздела "Планы и отчеты производства изделий"
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    NVERSION                PKG_STD.TREF;                          -- Версия контрагентов
    DDATE_FROM              PKG_STD.TLDATE;                        -- Дата с
    DDATE_TO                PKG_STD.TLDATE;                        -- Дата по
  begin
    /* Считываем версию контрагентов */
    FIND_VERSION_BY_COMPANY(NCOMPANY => NCOMPANY, SUNITCODE => 'AGNLIST', NVERSION => NVERSION);
    /* Определяем период записей */
    P_FIRST_LAST_DAY(DCALCDATE => sysdate, DBGNDATE => DDATE_FROM, DENDDATE => DDATE_TO);
    /* Начинаем формирование XML */
    PKG_XFAST.PROLOGUE(ITYPE => PKG_XFAST.CONTENT_);
    /* Открываем корень */
    PKG_XFAST.DOWN_NODE(SNAME => 'XDATA');
    /* Цикл по планам и отчетам производства изделий */
    for REC in (select P.RN NRN,
                       DT.DOCCODE || ', ' || trim(P.PREFIX) || '-' || trim(P.NUMB) || ', ' ||
                       TO_CHAR(P.DOCDATE, 'dd.mm.yyyy') SDOC_INFO,
                       D.CODE as SSUBDIV,
                       TO_CHAR(E.STARTDATE, 'mm.yyyy') as SPERIOD
                  from FCPRODPLAN     P,
                       FINSTATE       FS,
                       DOCTYPES       DT,
                       INS_DEPARTMENT D,
                       ENPERIOD       E
                 where P.CATEGORY = NFCPRODPLAN_DEPT_CTGR
                   and P.STATUS = NFCPRODPLAN_STATUS
                   and P.COMPANY = NCOMPANY
                   and P.SUBDIV in (select C.DEPTRN
                                      from CLNPSPFM      C,
                                           CLNPSPFMTYPES CT
                                     where exists (select null
                                              from CLNPERSONS CP
                                             where exists (select null
                                                      from AGNLIST T
                                                     where T.PERS_AUTHID = UTILIZER()
                                                       and CP.PERS_AGENT = T.RN
                                                       and T.VERSION = NVERSION)
                                               and C.PERSRN = CP.RN
                                               and CP.COMPANY = NCOMPANY)
                                       and C.COMPANY = NCOMPANY
                                       and C.BEGENG <= sysdate
                                       and (C.ENDENG >= sysdate or C.ENDENG is null)
                                       and C.CLNPSPFMTYPES = CT.RN
                                       and CT.IS_PRIMARY = 1)
                   and FS.RN = P.TYPE
                   and FS.CODE = SFCPRODPLAN_TYPE
                   and D.RN = P.SUBDIV
                   and DT.RN = P.DOCTYPE
                   and E.RN = P.CALC_PERIOD
                   and E.STARTDATE >= DDATE_FROM
                   and E.ENDDATE <= DDATE_TO
                   and exists (select /*+ INDEX(UP I_USERPRIV_JUR_PERS_ROLEID) */
                         null
                          from USERPRIV UP
                         where UP.JUR_PERS = P.JUR_PERS
                           and UP.UNITCODE = 'CostProductPlans'
                           and UP.ROLEID in (select /*+ INDEX(UR I_USERROLES_AUTHID_FK) */
                                              UR.ROLEID
                                               from USERROLES UR
                                              where UR.AUTHID = UTILIZER())
                        union all
                        select /*+ INDEX(UP I_USERPRIV_JUR_PERS_AUTHID) */
                         null
                          from USERPRIV UP
                         where UP.JUR_PERS = P.JUR_PERS
                           and UP.UNITCODE = 'CostProductPlans'
                           and UP.AUTHID = UTILIZER())
                 order by SDOC_INFO)
    loop
      /* Открываем план */
      PKG_XFAST.DOWN_NODE(SNAME => 'XFCPRODPLANS');
      /* Описываем план */
      PKG_XFAST.ATTR(SNAME => 'NRN', NVALUE => REC.NRN);
      PKG_XFAST.ATTR(SNAME => 'SDOC_INFO', SVALUE => REC.SDOC_INFO);
      PKG_XFAST.ATTR(SNAME => 'SSUBDIV', SVALUE => REC.SSUBDIV);
      PKG_XFAST.ATTR(SNAME => 'SPERIOD', SVALUE => REC.SPERIOD);
      /* Закрываем план */
      PKG_XFAST.UP();
    end loop;
    /* Закрываем корень */
    PKG_XFAST.UP();
    /* Сериализуем */
    COUT := PKG_XFAST.SERIALIZE_TO_CLOB();
    /* Завершаем формирование XML */
    PKG_XFAST.EPILOGUE();
  exception
    when others then
      /* Завершаем формирование XML */
      PKG_XFAST.EPILOGUE();
      /* Вернем ошибку */
      PKG_STATE.DIAGNOSTICS_STACKED();
      P_EXCEPTION(0, PKG_STATE.SQL_ERRM());
  end FCPRODPLAN_DEPT_INIT;
  
  /*
    Процедуры панели "Выдача сменного задания"
  */
  
  /* Выдать задания сменного задания */
  procedure FCJOBSSP_ISSUE
  (
    NFCJOBS                 in number                              -- Рег. номер сменного задания
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    NDICMUNTS               PKG_STD.TREF;                          -- Рег. номер ед. изм. дня
    DSTART_DATE             PKG_STD.TLDATE;                        -- Дата начала строки плана
    DEND_DATE               PKG_STD.TLDATE;                        -- Дата окончания строки плана
  begin
    /* Если сменное задание не указано */
    if (NFCJOBS is null) then
      P_EXCEPTION(0, 'Сменное задание не определено.');
    end if;
    /* Считываем единицу измерения минут */
    FIND_DICMUNTS_CODE(NFLAG_SMART  => 0,
                       NFLAG_OPTION => 0,
                       NCOMPANY     => NCOMPANY,
                       SMEAS_MNEMO  => SDICMUNTS_DAY,
                       NRN          => NDICMUNTS);
    /* Отбираем строки с пустым "Станок факт" */
    for REC in (select T.RN
                  from FCJOBSSP T
                 where T.PRN = NFCJOBS
                   and T.EQCONFIG is null)
    loop
      /* Удаляем строку */
      P_FCJOBSSP_BASE_DELETE(NRN => REC.RN, NCOMPANY => NCOMPANY);
    end loop;
    /* Цикл по станкам строк */
    for EQ in (select T.EQCONFIG from FCJOBSSP T where T.PRN = NFCJOBS group by T.EQCONFIG)
    loop
      /* Цикл по строкам с текущим станком */
      for REC in (select TMP.*,
                         DECODE(B.RN, null, TMP.DDOC_DATE, TMP.DDOC_DATE + B.BEG_TIME) DSTART,
                         F_DICMUNTS_BASE_RECALC_QUANT(0, TMP.COMPANY, TMP.MUNIT, TMP.LABOUR_PLAN, NDICMUNTS) NLABOUR,
                         ROWNUM RNUM
                    from (select T.*,
                                 J.DOCDATE DDOC_DATE,
                                 COALESCE(T.TBOPERMODESP, J.TBOPERMODESP) NTBOPERMODESP
                            from FCJOBS   J,
                                 FCJOBSSP T
                           where J.RN = NFCJOBS
                             and T.PRN = J.RN
                             and T.EQCONFIG = EQ.EQCONFIG
                           order by T.PRIOR_PARTY asc) TMP,
                         TBOPERMODESP B
                   where B.RN = TMP.NTBOPERMODESP)
      loop
        /* Если это первая строка - устанавливаем по смене */
        if (REC.RNUM = 1) then
          DSTART_DATE := REC.DSTART;
          DEND_DATE   := DSTART_DATE + REC.NLABOUR;
        else
          DSTART_DATE := DEND_DATE;
          DEND_DATE   := DSTART_DATE + REC.NLABOUR;
        end if;
        /* Обновляем запись строки */
        P_FCJOBSSP_BASE_UPDATE(NRN            => REC.RN,
                               NCOMPANY       => REC.COMPANY,
                               SNUMB          => REC.NUMB,
                               NTBOPERMODESP  => REC.TBOPERMODESP,
                               SBARCODE       => REC.BARCODE,
                               NFACEACC       => REC.FACEACC,
                               NMATRES        => REC.MATRES,
                               NNOMCLASSIF    => REC.NOMCLASSIF,
                               NARTICLE       => REC.ARTICLE,
                               NFCROUTSHTSP   => REC.FCROUTSHTSP,
                               SOPER_NUMB     => REC.OPER_NUMB,
                               NOPER_TPS      => REC.OPER_TPS,
                               SOPER_UK       => REC.OPER_UK,
                               NSIGN_CONTRL   => REC.SIGN_CONTRL,
                               NMANPOWER      => REC.MANPOWER,
                               NCATEGORY      => REC.CATEGORY,
                               DBEG_PLAN      => DSTART_DATE,
                               DEND_PLAN      => DEND_DATE,
                               DBEG_FACT      => REC.BEG_FACT,
                               DEND_FACT      => REC.END_FACT,
                               NQUANT_PLAN    => REC.QUANT_PLAN,
                               NQUANT_FACT    => REC.QUANT_FACT,
                               NNORM          => REC.NORM,
                               NT_SHT_FACT    => REC.T_SHT_FACT,
                               NT_PZ_PLAN     => REC.T_PZ_PLAN,
                               NT_PZ_FACT     => REC.T_PZ_FACT,
                               NT_VSP_PLAN    => REC.T_VSP_PLAN,
                               NT_VSP_FACT    => REC.T_VSP_FACT,
                               NT_O_PLAN      => REC.T_O_PLAN,
                               NT_O_FACT      => REC.T_O_FACT,
                               NNORM_TYPE     => REC.NORM_TYPE,
                               NSIGN_P_R      => REC.SIGN_P_R,
                               NLABOUR_PLAN   => REC.LABOUR_PLAN,
                               NLABOUR_FACT   => REC.LABOUR_FACT,
                               NCOST_PLAN     => REC.COST_PLAN,
                               NCOST_FACT     => REC.COST_FACT,
                               NCOST_FOR      => REC.COST_FOR,
                               NCURNAMES      => REC.CURNAMES,
                               NPERFORM_PLAN  => REC.PERFORM_PLAN,
                               NPERFORM_FACT  => REC.PERFORM_FACT,
                               NSTAFFGRP_PLAN => REC.STAFFGRP_PLAN,
                               NSTAFFGRP_FACT => REC.STAFFGRP_FACT,
                               NEQUIP_PLAN    => REC.EQUIP_PLAN,
                               NEQUIP_FACT    => REC.EQUIP_FACT,
                               NLOSTTYPE      => REC.LOSTTYPE,
                               NLOSTDEFL      => REC.LOSTDEFL,
                               NFOREMAN       => REC.FOREMAN,
                               NINSPECTOR     => REC.INSPECTOR,
                               DOTK_DATE      => REC.OTK_DATE,
                               NSUBDIV        => REC.SUBDIV,
                               NEQCONFIG      => REC.EQCONFIG,
                               SNOTE          => 'Задание выдано ' || TO_CHAR(sysdate, 'dd.mm.yyyy hh24:mi:ss'),
                               NMUNIT         => REC.MUNIT);
      end loop;
    end loop;
  end FCJOBSSP_ISSUE;
  
  /* Исключение станка из операции сменного задания */
  procedure FCJOBSSP_EXC_EQCONFIG
  (
    NFCJOBSSP               in number                              -- Рег. номер строки сменного задания
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    RFCJOBSSP               FCJOBSSP%rowtype;                      -- Запись строки сменного задания
  begin
    /* Если рег. номер строки не указан */
    if (NFCJOBSSP is null) then
      P_EXCEPTION(0, 'Строка сменного задания не определена.');
    end if;
    /* Считываем запись строки сменного задания */
    RFCJOBSSP := UTL_FCJOBSSP_GET(NCOMPANY => NCOMPANY, NFCJOBSSP => NFCJOBSSP);
    /* Если дата начала факт указана */
    if (RFCJOBSSP.BEG_FACT is not null) then
      P_EXCEPTION(0, 'Указанная строка сменного задания исполняется.');
    end if;
    /* Исключаем станок */
    P_FCJOBSSP_BASE_UPDATE(NRN            => RFCJOBSSP.RN,
                           NCOMPANY       => RFCJOBSSP.COMPANY,
                           SNUMB          => RFCJOBSSP.NUMB,
                           NTBOPERMODESP  => RFCJOBSSP.TBOPERMODESP,
                           SBARCODE       => RFCJOBSSP.BARCODE,
                           NFACEACC       => RFCJOBSSP.FACEACC,
                           NMATRES        => RFCJOBSSP.MATRES,
                           NNOMCLASSIF    => RFCJOBSSP.NOMCLASSIF,
                           NARTICLE       => RFCJOBSSP.ARTICLE,
                           NFCROUTSHTSP   => RFCJOBSSP.FCROUTSHTSP,
                           SOPER_NUMB     => RFCJOBSSP.OPER_NUMB,
                           NOPER_TPS      => RFCJOBSSP.OPER_TPS,
                           SOPER_UK       => RFCJOBSSP.OPER_UK,
                           NSIGN_CONTRL   => RFCJOBSSP.SIGN_CONTRL,
                           NMANPOWER      => RFCJOBSSP.MANPOWER,
                           NCATEGORY      => RFCJOBSSP.CATEGORY,
                           DBEG_PLAN      => RFCJOBSSP.BEG_PLAN,
                           DEND_PLAN      => RFCJOBSSP.END_PLAN,
                           DBEG_FACT      => RFCJOBSSP.BEG_FACT,
                           DEND_FACT      => RFCJOBSSP.END_FACT,
                           NQUANT_PLAN    => RFCJOBSSP.QUANT_PLAN,
                           NQUANT_FACT    => RFCJOBSSP.QUANT_FACT,
                           NNORM          => RFCJOBSSP.NORM,
                           NT_SHT_FACT    => RFCJOBSSP.T_SHT_FACT,
                           NT_PZ_PLAN     => RFCJOBSSP.T_PZ_PLAN,
                           NT_PZ_FACT     => RFCJOBSSP.T_PZ_FACT,
                           NT_VSP_PLAN    => RFCJOBSSP.T_VSP_PLAN,
                           NT_VSP_FACT    => RFCJOBSSP.T_VSP_FACT,
                           NT_O_PLAN      => RFCJOBSSP.T_O_PLAN,
                           NT_O_FACT      => RFCJOBSSP.T_O_FACT,
                           NNORM_TYPE     => RFCJOBSSP.NORM_TYPE,
                           NSIGN_P_R      => RFCJOBSSP.SIGN_P_R,
                           NLABOUR_PLAN   => RFCJOBSSP.LABOUR_PLAN,
                           NLABOUR_FACT   => RFCJOBSSP.LABOUR_FACT,
                           NCOST_PLAN     => RFCJOBSSP.COST_PLAN,
                           NCOST_FACT     => RFCJOBSSP.COST_FACT,
                           NCOST_FOR      => RFCJOBSSP.COST_FOR,
                           NCURNAMES      => RFCJOBSSP.CURNAMES,
                           NPERFORM_PLAN  => RFCJOBSSP.PERFORM_PLAN,
                           NPERFORM_FACT  => RFCJOBSSP.PERFORM_FACT,
                           NSTAFFGRP_PLAN => RFCJOBSSP.STAFFGRP_PLAN,
                           NSTAFFGRP_FACT => RFCJOBSSP.STAFFGRP_FACT,
                           NEQUIP_PLAN    => RFCJOBSSP.EQUIP_PLAN,
                           NEQUIP_FACT    => RFCJOBSSP.EQUIP_FACT,
                           NLOSTTYPE      => RFCJOBSSP.LOSTTYPE,
                           NLOSTDEFL      => RFCJOBSSP.LOSTDEFL,
                           NFOREMAN       => RFCJOBSSP.FOREMAN,
                           NINSPECTOR     => RFCJOBSSP.INSPECTOR,
                           DOTK_DATE      => RFCJOBSSP.OTK_DATE,
                           NSUBDIV        => RFCJOBSSP.SUBDIV,
                           NEQCONFIG      => null,
                           SNOTE          => RFCJOBSSP.NOTE,
                           NMUNIT         => RFCJOBSSP.MUNIT);
  end FCJOBSSP_EXC_EQCONFIG;
  
  /* Включение станка в строку сменного задания */
  procedure FCJOBSSP_INC_EQCONFIG
  (
    NEQCONFIG               in number,                             -- Рег. номер состава оборудования
    NFCJOBSSP               in number,                             -- Рег. номер строки сменного задания
    NQUANT_PLAN             in number                              -- Включаемое количество
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    NQUANT_REMN             PKG_STD.TLNUMBER;                      -- Остаток количества
    RFCJOBSSP               FCJOBSSP%rowtype;                      -- Запись строки сменного задания
    NNEW_FCJOBSSP           PKG_STD.TREF;                          -- Рег. номер новой строки сменного задания
    NROUTLST                PKG_STD.TREF;                          -- Рег. номер связанного МЛ
    NROUTLSTSP              PKG_STD.TREF;                          -- Рег. номер связанной строки МЛ
    
    /* Пересчет "Трудоемкость план" строки сменного задания */
    procedure LABOUR_PLAN_RECALC
    (
      RFCJOBSSP             in out FCJOBSSP%rowtype, -- Запись строки сменного задания
      NQUANT_PLAN           in number                -- Количество план
    )
    is
    begin
      /* Если не установлен признак "То план" */
      if ((RFCJOBSSP.T_O_PLAN is null) or ((RFCJOBSSP.T_O_PLAN is not null) and (RFCJOBSSP.T_O_PLAN = 0))) then
        /* Если установлен признак "На партию выпуска" */
        if (RFCJOBSSP.SIGN_P_R = 1) then
          RFCJOBSSP.LABOUR_PLAN := RFCJOBSSP.NORM;
        else
          RFCJOBSSP.LABOUR_PLAN := RFCJOBSSP.NORM * NQUANT_PLAN;
        end if;
      else
        /* Если установлен признак "На партию выпуска" */
        if (RFCJOBSSP.SIGN_P_R = 1) then
          RFCJOBSSP.LABOUR_PLAN := RFCJOBSSP.T_O_PLAN + COALESCE(RFCJOBSSP.T_PZ_PLAN, 0) +
                                   COALESCE(RFCJOBSSP.T_VSP_PLAN, 0);
        else
          RFCJOBSSP.LABOUR_PLAN := RFCJOBSSP.T_O_PLAN * NQUANT_PLAN + COALESCE(RFCJOBSSP.T_PZ_PLAN, 0) +
                                   COALESCE(RFCJOBSSP.T_VSP_PLAN, 0);
        end if;
      end if;
    end LABOUR_PLAN_RECALC;
  begin
    /* Если включаемое количество меньше 0 или пустое */
    if ((NQUANT_PLAN is null) or ((NQUANT_PLAN is not null) and (NQUANT_PLAN <= 0))) then
      P_EXCEPTION(0, 'Невозможно включить указанное количество.');
    end if;
    /* Если рабочее место выбрано */
    if (NEQCONFIG is not null) then
      /* Проверяем наличие состава оборудования */
      UTL_EQCONFIG_EXISTS(NEQCONFIG => NEQCONFIG, NCOMPANY => NCOMPANY);
    else
      P_EXCEPTION(0, 'Рабочее место не определено.');
    end if;
    /* Если рег. номер строки не указан */
    if (NFCJOBSSP is null) then
      P_EXCEPTION(0, 'Строка сменного задания не определена.');
    end if;
    /* Считываем запись строки сменного задания */
    RFCJOBSSP := UTL_FCJOBSSP_GET(NCOMPANY => NCOMPANY, NFCJOBSSP => NFCJOBSSP);
    /* Если дата начала факт указана */
    if (RFCJOBSSP.BEG_FACT is not null) then
      P_EXCEPTION(0, 'Указанная строка сменного задания исполняется.');
    end if;
    /* Если включаемое количество больше текущего */
    if (NQUANT_PLAN > RFCJOBSSP.QUANT_PLAN) then
      P_EXCEPTION(0,
                  'Указанное количество превышает текущее "Количество план" строки.');
    end if;
    /* Рассчитываем остаточное количество */
    NQUANT_REMN := RFCJOBSSP.QUANT_PLAN - NQUANT_PLAN;
    /* Пересчитываем "Количество план" */
    LABOUR_PLAN_RECALC(RFCJOBSSP => RFCJOBSSP, NQUANT_PLAN => NQUANT_PLAN);
    /* Включаем станок */
    P_FCJOBSSP_BASE_UPDATE(NRN            => RFCJOBSSP.RN,
                           NCOMPANY       => RFCJOBSSP.COMPANY,
                           SNUMB          => RFCJOBSSP.NUMB,
                           NTBOPERMODESP  => RFCJOBSSP.TBOPERMODESP,
                           SBARCODE       => RFCJOBSSP.BARCODE,
                           NFACEACC       => RFCJOBSSP.FACEACC,
                           NMATRES        => RFCJOBSSP.MATRES,
                           NNOMCLASSIF    => RFCJOBSSP.NOMCLASSIF,
                           NARTICLE       => RFCJOBSSP.ARTICLE,
                           NFCROUTSHTSP   => RFCJOBSSP.FCROUTSHTSP,
                           SOPER_NUMB     => RFCJOBSSP.OPER_NUMB,
                           NOPER_TPS      => RFCJOBSSP.OPER_TPS,
                           SOPER_UK       => RFCJOBSSP.OPER_UK,
                           NSIGN_CONTRL   => RFCJOBSSP.SIGN_CONTRL,
                           NMANPOWER      => RFCJOBSSP.MANPOWER,
                           NCATEGORY      => RFCJOBSSP.CATEGORY,
                           DBEG_PLAN      => RFCJOBSSP.BEG_PLAN,
                           DEND_PLAN      => RFCJOBSSP.END_PLAN,
                           DBEG_FACT      => RFCJOBSSP.BEG_FACT,
                           DEND_FACT      => RFCJOBSSP.END_FACT,
                           NQUANT_PLAN    => NQUANT_PLAN,
                           NQUANT_FACT    => RFCJOBSSP.QUANT_FACT,
                           NNORM          => RFCJOBSSP.NORM,
                           NT_SHT_FACT    => RFCJOBSSP.T_SHT_FACT,
                           NT_PZ_PLAN     => RFCJOBSSP.T_PZ_PLAN,
                           NT_PZ_FACT     => RFCJOBSSP.T_PZ_FACT,
                           NT_VSP_PLAN    => RFCJOBSSP.T_VSP_PLAN,
                           NT_VSP_FACT    => RFCJOBSSP.T_VSP_FACT,
                           NT_O_PLAN      => RFCJOBSSP.T_O_PLAN,
                           NT_O_FACT      => RFCJOBSSP.T_O_FACT,
                           NNORM_TYPE     => RFCJOBSSP.NORM_TYPE,
                           NSIGN_P_R      => RFCJOBSSP.SIGN_P_R,
                           NLABOUR_PLAN   => RFCJOBSSP.LABOUR_PLAN,
                           NLABOUR_FACT   => RFCJOBSSP.LABOUR_FACT,
                           NCOST_PLAN     => RFCJOBSSP.COST_PLAN,
                           NCOST_FACT     => RFCJOBSSP.COST_FACT,
                           NCOST_FOR      => RFCJOBSSP.COST_FOR,
                           NCURNAMES      => RFCJOBSSP.CURNAMES,
                           NPERFORM_PLAN  => RFCJOBSSP.PERFORM_PLAN,
                           NPERFORM_FACT  => RFCJOBSSP.PERFORM_FACT,
                           NSTAFFGRP_PLAN => RFCJOBSSP.STAFFGRP_PLAN,
                           NSTAFFGRP_FACT => RFCJOBSSP.STAFFGRP_FACT,
                           NEQUIP_PLAN    => RFCJOBSSP.EQUIP_PLAN,
                           NEQUIP_FACT    => RFCJOBSSP.EQUIP_FACT,
                           NLOSTTYPE      => RFCJOBSSP.LOSTTYPE,
                           NLOSTDEFL      => RFCJOBSSP.LOSTDEFL,
                           NFOREMAN       => RFCJOBSSP.FOREMAN,
                           NINSPECTOR     => RFCJOBSSP.INSPECTOR,
                           DOTK_DATE      => RFCJOBSSP.OTK_DATE,
                           NSUBDIV        => RFCJOBSSP.SUBDIV,
                           NEQCONFIG      => NEQCONFIG,
                           SNOTE          => RFCJOBSSP.NOTE,
                           NMUNIT         => RFCJOBSSP.MUNIT);
    /* Если есть остаток */
    if (NQUANT_REMN <> 0) then
      /* Обнуляем дату отработки */
      RFCJOBSSP.WORK_DATE := null;
      /* Получаем новый номер */
      P_FCJOBSSP_GETNEXTNUMB(NCOMPANY => NCOMPANY, NPRN => RFCJOBSSP.PRN, SNUMB => RFCJOBSSP.NUMB);
      /* Если штрихкод был указан */
      if (RFCJOBSSP.BARCODE is not null) then
        /* Получаем новый штрихкод */
        P_FCJOBSSP_GET_BARCODE(NCOMPANY => NCOMPANY, NRN => RFCJOBSSP.RN, SBARCODE => RFCJOBSSP.BARCODE);
      end if;
      /* Пересчитываем "Количество план" */
      LABOUR_PLAN_RECALC(RFCJOBSSP => RFCJOBSSP, NQUANT_PLAN => NQUANT_REMN);
      /* Размножаем запись */
      P_FCJOBSSP_BASE_INSERT(NCOMPANY       => RFCJOBSSP.COMPANY,
                             NPRN           => RFCJOBSSP.PRN,
                             SNUMB          => RFCJOBSSP.NUMB,
                             NTBOPERMODESP  => RFCJOBSSP.TBOPERMODESP,
                             SBARCODE       => RFCJOBSSP.BARCODE,
                             NFACEACC       => RFCJOBSSP.FACEACC,
                             NMATRES        => RFCJOBSSP.MATRES,
                             NNOMCLASSIF    => RFCJOBSSP.NOMCLASSIF,
                             NARTICLE       => RFCJOBSSP.ARTICLE,
                             NFCROUTSHTSP   => RFCJOBSSP.FCROUTSHTSP,
                             SOPER_NUMB     => RFCJOBSSP.OPER_NUMB,
                             NOPER_TPS      => RFCJOBSSP.OPER_TPS,
                             SOPER_UK       => RFCJOBSSP.OPER_UK,
                             NSIGN_CONTRL   => RFCJOBSSP.SIGN_CONTRL,
                             NMANPOWER      => RFCJOBSSP.MANPOWER,
                             NCATEGORY      => RFCJOBSSP.CATEGORY,
                             DBEG_PLAN      => RFCJOBSSP.BEG_PLAN,
                             DEND_PLAN      => RFCJOBSSP.END_PLAN,
                             DBEG_FACT      => RFCJOBSSP.BEG_FACT,
                             DEND_FACT      => RFCJOBSSP.END_FACT,
                             NQUANT_PLAN    => NQUANT_REMN,
                             NQUANT_FACT    => RFCJOBSSP.QUANT_FACT,
                             NNORM          => RFCJOBSSP.NORM,
                             NT_SHT_FACT    => RFCJOBSSP.T_SHT_FACT,
                             NT_PZ_PLAN     => RFCJOBSSP.T_PZ_PLAN,
                             NT_PZ_FACT     => RFCJOBSSP.T_PZ_FACT,
                             NT_VSP_PLAN    => RFCJOBSSP.T_VSP_PLAN,
                             NT_VSP_FACT    => RFCJOBSSP.T_VSP_FACT,
                             NT_O_PLAN      => RFCJOBSSP.T_O_PLAN,
                             NT_O_FACT      => RFCJOBSSP.T_O_FACT,
                             NNORM_TYPE     => RFCJOBSSP.NORM_TYPE,
                             NSIGN_P_R      => RFCJOBSSP.SIGN_P_R,
                             NLABOUR_PLAN   => RFCJOBSSP.LABOUR_PLAN,
                             NLABOUR_FACT   => RFCJOBSSP.LABOUR_FACT,
                             NCOST_PLAN     => RFCJOBSSP.COST_PLAN,
                             NCOST_FACT     => RFCJOBSSP.COST_FACT,
                             NCOST_FOR      => RFCJOBSSP.COST_FOR,
                             NCURNAMES      => RFCJOBSSP.CURNAMES,
                             NPERFORM_PLAN  => RFCJOBSSP.PERFORM_PLAN,
                             NPERFORM_FACT  => RFCJOBSSP.PERFORM_FACT,
                             NSTAFFGRP_PLAN => RFCJOBSSP.STAFFGRP_PLAN,
                             NSTAFFGRP_FACT => RFCJOBSSP.STAFFGRP_FACT,
                             NEQUIP_PLAN    => RFCJOBSSP.EQUIP_PLAN,
                             NEQUIP_FACT    => RFCJOBSSP.EQUIP_FACT,
                             NLOSTTYPE      => RFCJOBSSP.LOSTTYPE,
                             NLOSTDEFL      => RFCJOBSSP.LOSTDEFL,
                             NFOREMAN       => RFCJOBSSP.FOREMAN,
                             NINSPECTOR     => RFCJOBSSP.INSPECTOR,
                             DOTK_DATE      => RFCJOBSSP.OTK_DATE,
                             NSUBDIV        => RFCJOBSSP.SUBDIV,
                             NEQCONFIG      => null,
                             NSIGN_AR       => 1,
                             SNOTE          => RFCJOBSSP.NOTE,
                             NMUNIT         => RFCJOBSSP.MUNIT,
                             NPRIOR_ORDER   => RFCJOBSSP.PRIOR_ORDER,
                             NPRIOR_PARTY   => RFCJOBSSP.PRIOR_PARTY,
                             DEXEC_DATE     => RFCJOBSSP.EXEC_DATE,
                             DREL_DATE      => RFCJOBSSP.REL_DATE,
                             NRN            => NNEW_FCJOBSSP);
    
      /* связанные маршрутный лист и строка маршрутного листа */
      NROUTLST   := F_DOCLINKS_LINK_IN_DOC(SOUT_UNITCODE => 'CostJobsSpecs',
                                           NOUT_DOCUMENT => RFCJOBSSP.RN,
                                           SIN_UNITCODE  => 'CostRouteLists');
      NROUTLSTSP := F_DOCLINKS_LINK_IN_DOC(SOUT_UNITCODE => 'CostJobsSpecs',
                                           NOUT_DOCUMENT => RFCJOBSSP.RN,
                                           SIN_UNITCODE  => 'CostRouteListsSpecs');
    
      /* связывание с новой строкой сменного задания */
      if (NROUTLST is not null) and (NROUTLSTSP is not null) then
        /* Создаем связь с заголовоком МЛ */
        P_LINKSALL_LINK_DIRECT(NCOMPANY          => NCOMPANY,
                               SIN_UNITCODE      => 'CostRouteLists',
                               NIN_DOCUMENT      => NROUTLST,
                               NIN_PRN_DOCUMENT  => null,
                               DIN_IN_DATE       => sysdate,
                               NIN_STATUS        => 0,
                               SOUT_UNITCODE     => 'CostJobsSpecs',
                               NOUT_DOCUMENT     => NNEW_FCJOBSSP,
                               NOUT_PRN_DOCUMENT => RFCJOBSSP.PRN,
                               DOUT_IN_DATE      => sysdate,
                               NOUT_STATUS       => 0);
        /* Создаем связь со спецификацией МЛ */
        P_LINKSALL_LINK_DIRECT(NCOMPANY          => NCOMPANY,
                               SIN_UNITCODE      => 'CostRouteListsSpecs',
                               NIN_DOCUMENT      => NROUTLSTSP,
                               NIN_PRN_DOCUMENT  => NROUTLST,
                               DIN_IN_DATE       => sysdate,
                               NIN_STATUS        => 0,
                               SOUT_UNITCODE     => 'CostJobsSpecs',
                               NOUT_DOCUMENT     => NNEW_FCJOBSSP,
                               NOUT_PRN_DOCUMENT => RFCJOBSSP.PRN,
                               DOUT_IN_DATE      => sysdate,
                               NOUT_STATUS       => 0);
      end if;
    end if;
  end FCJOBSSP_INC_EQCONFIG;
  
  /* Получение спецификации сменного задания */
  procedure FCJOBSSP_DG_GET
  (
    NFCJOBS                 in number,                             -- Рег. номер сменного задания
    NPAGE_NUMBER            in number,                             -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- Количество записей на странице (0 - все)
    CORDERS                 in clob,                               -- Сортировки
    NINCLUDE_DEF            in number,                             -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob                               -- Сериализованная таблица данных
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    RO                      PKG_P8PANELS_VISUAL.TORDERS;           -- Сортировки
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- Описание таблицы
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы
    NROW_FROM               PKG_STD.TREF;                          -- Номер строки с
    NROW_TO                 PKG_STD.TREF;                          -- Номер строки по
    CSQL                    clob;                                  -- Буфер для запроса
    ICURSOR                 integer;                               -- Курсор для исполнения запроса
    NVERSION                PKG_STD.TREF;                          -- Версия контрагентов
  begin
    /* Читем сортировки */
    RO := PKG_P8PANELS_VISUAL.TORDERS_FROM_XML(CORDERS => CORDERS);
    /* Считываем версию контрагентов */
    FIND_VERSION_BY_COMPANY(NCOMPANY => NCOMPANY, SUNITCODE => 'AGNLIST', NVERSION => NVERSION);
    /* Преобразуем номер и размер страницы в номер строк с и по */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* Инициализируем таблицу данных */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE(BFIXED_HEADER => true, NFIXED_COLUMNS => 8);
    /* Описываем колонки таблицы данных */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => 'Рег. номер',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NSELECT',
                                               SCAPTION   => 'Выбран',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NPRIOR_PARTY',
                                               SCAPTION   => 'Приоритет партии',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               NWIDTH     => 80);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SFCROUTLST',
                                               SCAPTION   => 'МЛ',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SMATRES',
                                               SCAPTION   => 'ДСЕ',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SOPER',
                                               SCAPTION   => 'Операция',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NQUANT_PLAN',
                                               SCAPTION   => 'Количество',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NLABOUR_PLAN',
                                               SCAPTION   => 'Трудоемкость',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SEQCONFIG',
                                               SCAPTION   => 'Станок',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NEQCONFIG',
                                               SCAPTION   => 'Рег. номер станка',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NEQUIP_PLAN',
                                               SCAPTION   => 'Рег. номер оборудования',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DBEG_FACT',
                                               SCAPTION   => 'Дата начала факт',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE,
                                               BVISIBLE   => false);
    /* Обходим данные */
    begin
      /* Добавляем подсказку совместимости */
      CSQL := PKG_SQL_BUILD.COMPATIBLE(SSQL => CSQL);
      /* Формируем запрос */
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => 'select *');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '  from (select D.*,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => PKG_SQL_BUILD.SQLROWNUM() || ' NROW');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '          from (select T.RN NRN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.PRIOR_PARTY NPRIOR_PARTY,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       (select ' || PKG_SQL_BUILD.SET_HINT(SHINT => 'INDEX(L I_DOCLINKS_OUT_DOCUMENT)'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               TRIM(D.DOCNUMB) || '' '' || to_char(D.DOCDATE, ''dd.mm.yyyy'')');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                          from DOCLINKS  L,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               FCROUTLST D');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                         where L.OUT_DOCUMENT = T.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and L.OUT_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostJobsSpecs'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and L.IN_DOCUMENT = D.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and L.IN_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           ' || PKG_SQL_BUILD.ROWLIMIT(NLIMIT => 1, BAND => true) || ') SFCROUTLST,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       MR.CODE || '' '' || MR."NAME" SMATRES,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       TRIM(T.OPER_NUMB) || '' '' || ( select coalesce(O."NAME", T.OPER_UK) from FCOPERTYPES O where T.OPER_TPS = O.RN ) SOPER,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.QUANT_PLAN NQUANT_PLAN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.LABOUR_PLAN NLABOUR_PLAN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       (select IQ.CODE from EQCONFIG IQ where T.EQCONFIG = IQ.RN) SEQCONFIG,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.EQCONFIG NEQCONFIG,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.EQUIP_PLAN NEQUIP_PLAN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.BEG_FACT DBEG_FACT');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                  from FCJOBSSP T,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       FCMATRESOURCE MR');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                 where T.PRN = :NFCJOBS');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.COMPANY = :NCOMPANY');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.SIGN_CONTRL = ' || PKG_SQL_BUILD.WRAP_NUM(NVALUE => 0));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and MR.RN = T.MATRES');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                 %ORDER_BY%) D) F');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => ' where F.NROW between :NROW_FROM and :NROW_TO');
      /* Если сортировки не указаны */
      if (CORDERS is not null) then
        /* Учтём сортировки */
        PKG_P8PANELS_VISUAL.TORDERS_SET_QUERY(RDATA_GRID => RDG, RORDERS => RO, SPATTERN => '%ORDER_BY%', CSQL => CSQL);
      else
        /* Устанавливаем стандартную сортировку */
        CSQL := replace(CSQL, '%ORDER_BY%', 'order by T.PRIOR_PARTY asc, T.BEG_PLAN asc');
      end if;
      /* Разбираем его */
      ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
      PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
      /* Делаем подстановку параметров */
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NFCJOBS', NVALUE => NFCJOBS);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NCOMPANY', NVALUE => NCOMPANY);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
      /* Описываем структуру записи курсора */
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 1);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 2);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 3);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 4);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 5);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 6);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 7);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 8);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 9);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 10);
      PKG_SQL_DML.DEFINE_COLUMN_DATE(ICURSOR => ICURSOR, IPOSITION => 11);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 12);
      /* Делаем выборку */
      if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
        null;
      end if;
      /* Обходим выбранные записи */
      while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
      loop
        /* Добавляем колонки с данными */
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NRN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 1,
                                              BCLEAR    => true);
        PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NSELECT', NVALUE => 0);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NPRIOR_PARTY',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 2);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SFCROUTLST',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 3);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SMATRES', ICURSOR => ICURSOR, NPOSITION => 4);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SOPER', ICURSOR => ICURSOR, NPOSITION => 5);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NQUANT_PLAN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 6);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NLABOUR_PLAN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 7);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                              SNAME     => 'SEQCONFIG',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 8);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NEQCONFIG',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 9);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NEQUIP_PLAN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 10);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLD(RROW      => RDG_ROW,
                                              SNAME     => 'DBEG_FACT',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 11);
        /* Добавляем строку в таблицу */
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
      end loop;
    exception
      when others then
        PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
        raise;
    end;
    /* Сериализуем описание */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  end FCJOBSSP_DG_GET;
  
  /* Получение составов оборудования подразделения */
  procedure EQCONFIG_DG_GET
  (
    NFCJOBS                 in number,                             -- Рег. номер сменного задания
    NPAGE_NUMBER            in number,                             -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- Количество записей на странице (0 - все)
    CORDERS                 in clob,                               -- Сортировки
    NINCLUDE_DEF            in number,                             -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob                               -- Сериализованная таблица данных
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    RO                      PKG_P8PANELS_VISUAL.TORDERS;           -- Сортировки
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- Описание таблицы
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы
    NROW_FROM               PKG_STD.TREF;                          -- Номер строки с
    NROW_TO                 PKG_STD.TREF;                          -- Номер строки по
    CSQL                    clob;                                  -- Буфер для запроса
    ICURSOR                 integer;                               -- Курсор для исполнения запроса
    NSUBDIV                 PKG_STD.TNUMBER;                       -- Рег. номер подразделения пользователя
    NEQCONFIG               PKG_STD.TNUMBER;                       -- Рег. номер станка
    NSUM_LABOUR             PKG_STD.TLNUMBER;                      -- Сумма трудоемкости
    NSUM_WORK_TIME          PKG_STD.TLNUMBER;                      -- Сумма рабочего времени
    NLOADING                PKG_STD.TLNUMBER;                      -- Загрузка оборудования
    NDICMUNTS_MIN           PKG_STD.TREF;                          -- Рег. номер ед. изм. минут
    NDICMUNTS_WD            PKG_STD.TREF;                          -- Рег. номер ед. изм. нормочасов
  begin
    /* Читем сортировки */
    RO := PKG_P8PANELS_VISUAL.TORDERS_FROM_XML(CORDERS => CORDERS);
    /* Преобразуем номер и размер страницы в номер строк с и по */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* Инициализируем таблицу данных */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE(BFIXED_HEADER => true, NFIXED_COLUMNS => 4);
    /* Описываем колонки таблицы данных */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => 'Рег. номер',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NSELECT',
                                               SCAPTION   => 'Выбран',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SCODE',
                                               SCAPTION   => 'Станок',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NSUM_LABOUR',
                                               SCAPTION   => 'Загрузка в н/ч',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NLOADING',
                                               SCAPTION   => 'Загрузка в %',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BORDER     => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NEQUIPMENT',
                                               SCAPTION   => 'Рег. номер оборудования',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    /* Считываем единицу измерения минут */
    FIND_DICMUNTS_CODE(NFLAG_SMART  => 0,
                       NFLAG_OPTION => 0,
                       NCOMPANY     => NCOMPANY,
                       SMEAS_MNEMO  => SDICMUNTS_MIN,
                       NRN          => NDICMUNTS_MIN);
    /* Считываем единицу измерения минут */
    FIND_DICMUNTS_CODE(NFLAG_SMART  => 0,
                       NFLAG_OPTION => 0,
                       NCOMPANY     => NCOMPANY,
                       SMEAS_MNEMO  => SDICMUNTS_WD,
                       NRN          => NDICMUNTS_WD);
    /* Считываем рег. номер подразделения пользователя */
    NSUBDIV := UTL_SUBDIV_RN_GET(NCOMPANY => NCOMPANY, SUSER => UTILIZER());
    /* Если подразделение считано */
    if (NSUBDIV is not null) then
      /* Обходим данные */
      begin
        /* Добавляем подсказку совместимости */
        CSQL := PKG_SQL_BUILD.COMPATIBLE(SSQL => CSQL);
        /* Формируем запрос */
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => 'select *');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '  from (select D.*,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => PKG_SQL_BUILD.SQLROWNUM() || ' NROW');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '          from (select T.RN NRN,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.CODE SCODE,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       SE.EQUIPMENT NEQUIPMENT');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                  from SUBDIVSEQ SE,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       EQCONFIG  T');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                 where SE.PRN = :NSUBDIV');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and SE.COMPANY = :NCOMPANY');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.RN = SE.EQCONFIG');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                 %ORDER_BY%) D) F');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => ' where F.NROW between :NROW_FROM and :NROW_TO');
        /* Учтём сортировки */
        PKG_P8PANELS_VISUAL.TORDERS_SET_QUERY(RDATA_GRID => RDG, RORDERS => RO, SPATTERN => '%ORDER_BY%', CSQL => CSQL);
        /* Разбираем его */
        ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
        PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
        /* Делаем подстановку параметров */
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NSUBDIV', NVALUE => NSUBDIV);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NCOMPANY', NVALUE => NCOMPANY);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
        /* Описываем структуру записи курсора */
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 1);
        PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 2);
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 3);
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 4);
        /* Делаем выборку */
        if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
          null;
        end if;
        /* Обходим выбранные записи */
        while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
        loop
          /* Читаем данные из курсора рег. номер станка */
          PKG_SQL_DML.COLUMN_VALUE_NUM(ICURSOR => ICURSOR, IPOSITION => 1, NVALUE => NEQCONFIG);
          /* Обнуляем сумму рабочего времени и трудоемкости */
          NSUM_LABOUR    := 0;
          NSUM_WORK_TIME := 0;
          /* Цикл по различным сменам данного оборудования */
          for REC in (select TMP.TBOPERMODESP,
                             sum(TMP.NLABOUR) NLABOUR
                        from (select COALESCE(T.TBOPERMODESP, J.TBOPERMODESP) TBOPERMODESP,
                                     F_DICMUNTS_BASE_RECALC_QUANT(0, T.COMPANY, T.MUNIT, T.LABOUR_PLAN, NDICMUNTS_MIN) NLABOUR
                                from FCJOBS   J,
                                     FCJOBSSP T
                               where J.RN = NFCJOBS
                                 and T.PRN = J.RN
                                 and T.EQCONFIG = NEQCONFIG) TMP
                       group by TMP.TBOPERMODESP)
          loop
            /* Рассчитываем суммы */
            NSUM_LABOUR    := NSUM_LABOUR + REC.NLABOUR;
            NSUM_WORK_TIME := NSUM_WORK_TIME + UTL_WORK_TIME_GET(NTBOPERMODESP => REC.TBOPERMODESP);
          end loop;
          /* Если оборудование не участвует в сменном задании */
          if (NSUM_WORK_TIME = 0) then
            NLOADING := 0;
          else
            NLOADING := ROUND(NSUM_LABOUR / NSUM_WORK_TIME * 100, 0);
            /* Если трудоемкость не равна 0 */
            if (NSUM_LABOUR <> 0) then
              /* Переводим суммарную трудоемкость в нормочасы */
              NSUM_LABOUR := ROUND(F_DICMUNTS_BASE_RECALC_QUANT(0, NCOMPANY, NDICMUNTS_MIN, NSUM_LABOUR, NDICMUNTS_WD),
                                   2);
            end if;
          end if;
          /* Добавляем колонки с данными */
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NRN', NVALUE => NEQCONFIG, BCLEAR => true);
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NSELECT', NVALUE => 0);
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NSUM_LABOUR', NVALUE => NSUM_LABOUR);
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SCODE', ICURSOR => ICURSOR, NPOSITION => 2);
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NLOADING', NVALUE => NLOADING);
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                                SNAME     => 'NEQUIPMENT',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 3);
          /* Добавляем строку в таблицу */
          PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
        end loop;
      exception
        when others then
          PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
          raise;
      end;
    end if;
    /* Сериализуем описание */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  end EQCONFIG_DG_GET;
  
  /* Инициализация записей раздела "Планы и отчеты производства изделий" */
  procedure FCJOBS_INIT
  (
    COUT                    out clob                               -- Список записей раздела "Сменные задания"
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    SUTILIZER               PKG_STD.TSTRING := UTILIZER();         -- Пользователь сеанса
    NVERSION                PKG_STD.TREF;                          -- Версия контрагентов
    SDOC_INFO               PKG_STD.TSTRING;                       -- Информация о документе
  begin
    /* Считываем версию контрагентов */
    FIND_VERSION_BY_COMPANY(NCOMPANY => NCOMPANY, SUNITCODE => 'AGNLIST', NVERSION => NVERSION);
    /* Начинаем формирование XML */
    PKG_XFAST.PROLOGUE(ITYPE => PKG_XFAST.CONTENT_);
    /* Открываем корень */
    PKG_XFAST.DOWN_NODE(SNAME => 'XDATA');
    /* Цикл по планам и отчетам производства изделий */
    for REC in (select T.RN NRN,
                       trim(T.DOCNUMB) SDOC_NUMB,
                       DT.DOCCODE || ', ' || trim(T.DOCPREF) || '-' || trim(T.DOCNUMB) || ', ' ||
                       TO_CHAR(T.DOCDATE, 'dd.mm.yyyy') SDOC_INFO,
                       INS.NAME SSUBDIV,
                       case
                         when PER.RN is not null then
                          TO_CHAR(T.DOCDATE, 'dd.mm.yyyy') || ' ' || TN2S(PER.BEG_TIME) || ' - ' || TN2S(PER.END_TIME)
                         else
                          TO_CHAR(T.DOCDATE, 'dd.mm.yyyy')
                       end SPERIOD,
                       (select trim(T2.NUMB) from TBOPERMODESP T2 where T.TBOPERMODESP = T2.RN) STBOPERMODESP,
                       (select 1
                          from FCJOBSSP S
                         where S.PRN = T.RN
                           and S.NOTE is not null
                           and ROWNUM = 1) NHAVE_NOTE
                  from FCJOBS         T,
                       DOCTYPES       DT,
                       INS_DEPARTMENT INS,
                       TBOPERMODESP   PER
                 where T.COMPANY = NCOMPANY
                   and T.STATE = NFCJOBS_STATUS_NOT_WO
                   and T.DOCDATE >= TRUNC(sysdate)
                   and DT.RN = T.DOCTYPE
                   and T.SUBDIV = INS.RN(+)
                   and T.TBOPERMODESP = PER.RN(+)
                   and PKG_P8PANELS_MECHREC.UTL_SUBDIV_CHECK(T.COMPANY, T.SUBDIV, SUTILIZER) = 1
                   and exists (select null from V_USERPRIV UP where UP.CATALOG = T.CRN)
                   and exists (select null
                          from V_USERPRIV UP
                         where UP.JUR_PERS = T.JUR_PERS
                           and UP.UNITCODE = 'CostJobs')
                 order by SDOC_INFO)
    loop
      /* Открываем план */
      PKG_XFAST.DOWN_NODE(SNAME => 'XFCJOBS');
      /* Описываем план */
      PKG_XFAST.ATTR(SNAME => 'NRN', NVALUE => REC.NRN);
      /* Если указана смена */
      if (REC.STBOPERMODESP is not null) then
        /* Указываем информацию документа со сменой */
        SDOC_INFO := REC.SDOC_INFO || ', смена ' || REC.STBOPERMODESP;
      else
        /* Указываем информацию документа без смены */
        SDOC_INFO := REC.SDOC_INFO;
      end if;
      PKG_XFAST.ATTR(SNAME => 'SDOC_INFO', SVALUE => SDOC_INFO);
      PKG_XFAST.ATTR(SNAME => 'SDOC_NUMB', SVALUE => REC.SDOC_NUMB);
      PKG_XFAST.ATTR(SNAME => 'SSUBDIV', SVALUE => REC.SSUBDIV);
      PKG_XFAST.ATTR(SNAME => 'SPERIOD', SVALUE => REC.SPERIOD);
      PKG_XFAST.ATTR(SNAME => 'NHAVE_NOTE', NVALUE => COALESCE(REC.NHAVE_NOTE, 0));
      /* Закрываем план */
      PKG_XFAST.UP();
    end loop;
    /* Закрываем корень */
    PKG_XFAST.UP();
    /* Сериализуем */
    COUT := PKG_XFAST.SERIALIZE_TO_CLOB();
    /* Завершаем формирование XML */
    PKG_XFAST.EPILOGUE();
  exception
    when others then
      /* Завершаем формирование XML */
      PKG_XFAST.EPILOGUE();
      /* Вернем ошибку */
      PKG_STATE.DIAGNOSTICS_STACKED();
      P_EXCEPTION(0, PKG_STATE.SQL_ERRM());
  end FCJOBS_INIT;
  
  /*
    Процедуры панели "Загрузка цеха"
  */
  
  /* Получение количества рабочих часов в сменах подразделения */
  procedure INS_DEPARTMENT_WORKHOURS_GET
  (
    NSUBDIV                 in number,                             -- Рег. номер подразделения
    NWORKHOURS              out number                             -- Количество рабочих часов
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
  begin
    /* Инициализируем значение */
    NWORKHOURS := 0;
    /* Цикл по сменам подразделения */
    for REC in (select SP.RN
                  from INS_DEPARTMENT T,
                       SLSCHEDULE     S,
                       TBOPERMODE     O,
                       TBOPERMODESP   SP
                 where T.RN = NSUBDIV
                   and T.COMPANY = NCOMPANY
                   and S.RN = T.SCHEDULE
                   and O.RN = S.TBOPERMODE
                   and SP.PRN = O.RN)
    loop
      /* Суммируем количество рабочих часов смены */
      NWORKHOURS := NWORKHOURS + COALESCE(UTL_WORK_TIME_GET(NTBOPERMODESP => REC.RN) / 60, 0);
    end loop;
  end INS_DEPARTMENT_WORKHOURS_GET;
  
  /* Получение количества рабочих дней месяца */
  procedure ENPERIOD_WORKDAYS_GET
  (
    SMONTH_YEAR             in varchar2,                           -- Строковое представления месяца и года в формате (mm.yyyy)
    NWORKDAYS               out number                             -- Количество рабочих дней
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    DDATE_FROM              PKG_STD.TLDATE;                        -- Дата с
    DDATE_TO                PKG_STD.TLDATE;                        -- Дата по
  begin
    /* Считываем первый и последний день месяца */
    P_FIRST_LAST_DAY(DCALCDATE => TO_DATE(SMONTH_YEAR, 'mm.yyyy'), DBGNDATE => DDATE_FROM, DENDDATE => DDATE_TO);
    /* Определяем количество рабочих дней по детализации */
    begin
      select COALESCE(count(TMP.DAYS), 0)
        into NWORKDAYS
        from (select W.DAYS
                from WORKDAYS   W,
                     WORKDAYSTR S
               where W.PRN = (select T.RN
                                from ENPERIOD T
                               where T.COMPANY = NCOMPANY
                                 and T.PERTYPE = 0
                                 and T.PER_TYPE = 4
                                 and T.MAIN_SIGN = 1
                                 and T.STARTDATE = DDATE_FROM
                                 and T.ENDDATE = DDATE_TO)
                 and S.PRN = W.RN
               group by W.DAYS
              having sum(S.HOURSNORM) <> 0) TMP;
    exception
      when others then
        NWORKDAYS := 0;
    end;
  end ENPERIOD_WORKDAYS_GET;
  
  /* Получение таблицы доступных подразделений (цехов) */
  procedure INS_DEPARTMENT_DG_GET
  (
    SMONTH_YEAR             in varchar2,                           -- Строковое представления месяца и года в формате (mm.yyyy)
    NPAGE_NUMBER            in number,                             -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- Количество записей на странице (0 - все)
    NINCLUDE_DEF            in number,                             -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob                               -- Сериализованная таблица данных
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- Описание таблицы
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы
    NROW_FROM               PKG_STD.TREF;                          -- Номер строки с
    NROW_TO                 PKG_STD.TREF;                          -- Номер строки по
    CSQL                    clob;                                  -- Буфер для запроса
    ICURSOR                 integer;                               -- Курсор для исполнения запроса
    DDATE_FROM              PKG_STD.TLDATE;                        -- Дата с
    DDATE_TO                PKG_STD.TLDATE;                        -- Дата по
  begin
    /* Преобразуем номер и размер страницы в номер строк с и по */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* Инициализируем таблицу данных */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE();
    /* Описываем колонки таблицы данных */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => 'Рег. номер',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SCODE',
                                               SCAPTION   => 'Мнемокод',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SNAME',
                                               SCAPTION   => 'Наименование',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DBGNDATE',
                                               SCAPTION   => 'Действует с',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'DENDDATE',
                                               SCAPTION   => 'Действует по',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_DATE);
    /* Считываем первый и последний день месяца */
    P_FIRST_LAST_DAY(DCALCDATE => TO_DATE(SMONTH_YEAR, 'mm.yyyy'), DBGNDATE => DDATE_FROM, DENDDATE => DDATE_TO);
    /* Обходим данные */
    begin
      /* Добавляем подсказку совместимости */
      CSQL := PKG_SQL_BUILD.COMPATIBLE(SSQL => CSQL);
      /* Формируем запрос */
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => 'select *');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '  from (select D.*,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => PKG_SQL_BUILD.SQLROWNUM() || ' NROW');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '          from (select T.RN NRN,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.CODE SCODE,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T."NAME" SNAME,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.BGNDATE DBGNDATE,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.ENDDATE DENDDATE');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                  from INS_DEPARTMENT T,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       SDIVTYPES      S');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                 where T.COMPANY = :NCOMPANY');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.SDIVTYPE = S.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and S.CODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'Цех'));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.BGNDATE <= :DDATE_TO');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and ((T.ENDDATE is null) or ((T.ENDDATE is not null) and (T.ENDDATE >= :DDATE_FROM)))');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and ' || PKG_SQL_BUILD.PKG_NAME(SNAME => 'PKG_P8PANELS_MECHREC.UTL_INS_DEP_HIER_EQ_CHECK') || '(T.COMPANY, T.RN, :DDATE_TO) = 1');
      /*PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and exists (');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               select null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 from INS_DEPARTMENT H');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                where H.COMPANY = :NCOMPANY');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  and exists (select null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                from SUBDIVSEQ EQ,');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                     EQCONFIG  EQC');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                               where EQ.PRN = H.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                 and EQC.RN = EQ.EQCONFIG');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                 and EQC.OPER_DATE is not null');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                 and EQC.OPER_DATE <= :DDATE_TO');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                 ' || PKG_SQL_BUILD.ROWLIMIT(NLIMIT => 1, BAND => true) || ')');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  ' || PKG_SQL_BUILD.ROWLIMIT(NLIMIT => 1, BAND => true));
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                start with H.RN = T.RN');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                              connect by prior H.RN = H.PRN)');*/
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                    ) D) F');
      PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => ' where F.NROW between :NROW_FROM and :NROW_TO');
      /* Разбираем его */
      ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
      PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
      /* Делаем подстановку параметров */
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NCOMPANY', NVALUE => NCOMPANY);
      PKG_SQL_DML.BIND_VARIABLE_DATE(ICURSOR => ICURSOR, SNAME => 'DDATE_FROM', DVALUE => DDATE_FROM);
      PKG_SQL_DML.BIND_VARIABLE_DATE(ICURSOR => ICURSOR, SNAME => 'DDATE_TO', DVALUE => DDATE_TO);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
      PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
      /* Описываем структуру записи курсора */
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 1);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 2);
      PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 3);
      PKG_SQL_DML.DEFINE_COLUMN_DATE(ICURSOR => ICURSOR, IPOSITION => 4);
      PKG_SQL_DML.DEFINE_COLUMN_DATE(ICURSOR => ICURSOR, IPOSITION => 5);
      PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 6);
      /* Делаем выборку */
      if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
        null;
      end if;
      /* Обходим выбранные записи */
      while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
      loop
        /* Добавляем колонки с данными */
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                              SNAME     => 'NRN',
                                              ICURSOR   => ICURSOR,
                                              NPOSITION => 1,
                                              BCLEAR    => true);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SCODE', ICURSOR => ICURSOR, NPOSITION => 2);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SNAME', ICURSOR => ICURSOR, NPOSITION => 3);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLD(RROW => RDG_ROW, SNAME => 'DBGNDATE', ICURSOR => ICURSOR, NPOSITION => 4);
        PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLD(RROW => RDG_ROW, SNAME => 'DENDDATE', ICURSOR => ICURSOR, NPOSITION => 5);
        /* Добавляем строку в таблицу */
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
      end loop;
    exception
      when others then
        PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
        raise;
    end;
    /* Сериализуем описание */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  end INS_DEPARTMENT_DG_GET;
  
  /* Получение загрузки цеха */
  procedure FCJOBS_DEP_LOAD_DG_GET
  (
    NSUBDIV                 in number,                             -- Рег. номер подразделения (цеха)
    SMONTH_YEAR             in varchar2,                           -- Строковое представления месяца и года в формате (mm.yyyy)
    NWORKHOURS              in number,                             -- Количество рабочих часов
    NPAGE_NUMBER            in number,                             -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- Количество записей на странице (0 - все)
    CORDERS                 in clob,                               -- Сортировки
    NINCLUDE_DEF            in number,                             -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob                               -- Сериализованная таблица данных
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    SUTILIZER               PKG_STD.TSTRING := UTILIZER();         -- Пользователь сеанса
    RO                      PKG_P8PANELS_VISUAL.TORDERS;           -- Сортировки
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- Описание таблицы
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы
    NROW_FROM               PKG_STD.TREF;                          -- Номер строки с
    NROW_TO                 PKG_STD.TREF;                          -- Номер строки по
    CSQL                    clob;                                  -- Буфер для запроса
    ICURSOR                 integer;                               -- Курсор для исполнения запроса
    DDATE_FROM              PKG_STD.TLDATE;                        -- Дата начала месяца
    DDATE_TO                PKG_STD.TLDATE;                        -- Дата окончания месяца
    DDATE                   PKG_STD.TLDATE;                        -- Дата для расчетов
    NDICMUNTS_WD            PKG_STD.TREF;                          -- Рег. номер единицы измерения нормочасов
    NEQCONFIG               PKG_STD.TREF;                          -- Рег. номер станка
    TDAYS                   TJOB_DAYS;                             -- Коллекция дней месяца
    NINDEX                  PKG_STD.TNUMBER;                       -- Индекс даты в коллекции дат
    NLOAD                   PKG_STD.TLNUMBER;                      -- Загрузка в нормочасах
    NPROCENT_LOAD           PKG_STD.TLNUMBER;                      -- Загрузка в %
    NENPERIOD               PKG_STD.TREF;                          -- Рег. номер рабочего календаря
    DCURRENT_DAY            PKG_STD.TLDATE;                        -- Текущий день
    
    /* Считывание типа дня (см. константы NDAY_TYPE_*) */
    function DAY_TYPE_GET
    (
      NENPERIOD             in number,       -- Рег. номер рабочего календаря
      DDATE                 in date,         -- Дата
      DCURRENT_DAY          in date          -- Текущая дата
    ) return                number           -- Тип дня (см. константы NDAY_TYPE_*)
    is
      NHOLIDAY              PKG_STD.TNUMBER; -- Тип дня (0 - рабочий, 1 - выходной)
      NDAY                  PKG_STD.TNUMBER; -- День
      NRESULT               PKG_STD.TNUMBER; -- Тип дня (см. константы NDAY_TYPE_*)
    begin
      /* Считываем день */
      NDAY := D_DAY(DDATE => DDATE);
      /* Проверяем начиличе записи в календаре, если такого дня нет в календаре или сумма часов = 0 - выходной */
      begin
        select 1
          into NHOLIDAY
          from DUAL
         where not exists (select null
                  from WORKDAYS T
                 where T.PRN = NENPERIOD
                   and T.DAYS = NDAY)
            or ((select COALESCE(sum(S.HOURSNORM), 0)
                   from WORKDAYS   T,
                        WORKDAYSTR S
                  where T.PRN = NENPERIOD
                    and T.DAYS = NDAY
                    and S.PRN = T.RN) = 0);
      exception
        when others then
          NHOLIDAY := 0;
      end;
      /* Исходим от дня */
      case
        /* Если это последующий день */
        when (DDATE > DCURRENT_DAY) then
          /* Если это рабочий день */
          if (NHOLIDAY = 0) then
            NRESULT := NDAY_TYPE_WORK_AFTER;
          else
            NRESULT := NDAY_TYPE_HOLIDAY_AFTER;
          end if;
        /* Если это предыдущий день */
        when (DDATE < DCURRENT_DAY) then
          /* Если это рабочий день */
          if (NHOLIDAY = 0) then
            NRESULT := NDAY_TYPE_WORK_BEFORE;
          else
            NRESULT := NDAY_TYPE_HOLIDAY_BEFORE;
          end if;
        /* Если это текущий день */
        else
          NRESULT := NDAY_TYPE_CURRENT_DAY;
      end case;
      /* Возвращаем результат */
      return NRESULT;
    end DAY_TYPE_GET;
    
    /* Считывание рег. номера рабочего календаря */
    function ENPERIOD_GET
    (
      NCOMPANY              in number,    -- Рег. номер организации
      DDATE_FROM            in date,      -- Дата начала периода
      DDATE_TO              in date       -- Дата окончания периода
    ) return                number        -- Рег. номер рабочего календаря
    is
      NRESULT               PKG_STD.TREF; -- Рег. номер рабочего календаря
    begin
      /* Считываем рег. номер рабочего календаря */
      begin
        select T.RN
          into NRESULT
          from ENPERIOD T
         where T.COMPANY = NCOMPANY
           and T.STARTDATE = DDATE_FROM
           and T.ENDDATE = DDATE_TO
           and T.PERTYPE = 0
           and T.PER_TYPE = 4
           and T.MAIN_SIGN = 1;
      exception
        when others then
          NRESULT := null;
      end;
      /* Возвращаем результат */
      return NRESULT;
    end ENPERIOD_GET;
    
    /* Считывание индекса коллекции дней */
    function TDAYS_INDEX_GET
    (
      TDAYS                 in TJOB_DAYS, -- Коллекция дней
      DDATE                 in date       -- Дата дня
    ) return                number        -- Индекс дня в коллекции
    is
    begin
      /* Цикл по дням месяца */
      for I in TDAYS.FIRST .. TDAYS.LAST
      loop
        /* Если это искомый день */
        if (TDAYS(I).DDATE = DDATE) then
          /* Возвращаем индекс */
          return I;
        end if;
      end loop;
      /* Возвращаем null */
      return null;
    end TDAYS_INDEX_GET;
    
    /* Инициализация дней месяца */
    procedure DAYS_INIT
    (
      RDG                   in out nocopy PKG_P8PANELS_VISUAL.TDATA_GRID, -- Описание таблицы
      TJOB_DAYS             in out nocopy TJOB_DAYS,                      -- Коллекция дней месяца
      DDATE_FROM            in date,                                      -- Дата начала месяца
      DDATE_TO              in date                                       -- Дата окончания месяца
    )
    is
      DDATE                 PKG_STD.TLDATE;                               -- Сформированная дата дня
      NMONTH                PKG_STD.TNUMBER;                              -- Текущий месяц
      NYEAR                 PKG_STD.TNUMBER;                              -- Текущий год
      SDATE_NAME            PKG_STD.TSTRING;                              -- Строковое представление даты для наименования колонки
    begin
      /* Считываем месяц и год текущей даты */
      NMONTH := D_MONTH(DDATE => DDATE_FROM);
      NYEAR  := D_YEAR(DDATE => DDATE_FROM);
      /* Цикл по дням месяца */
      for I in D_DAY(DDATE => DDATE_FROM) .. D_DAY(DDATE => DDATE_TO)
      loop
        /* Формируем дату дня */
        DDATE := TO_DATE(TO_CHAR(I) || '.' || TO_CHAR(NMONTH) || '.' || TO_CHAR(NYEAR), 'dd.mm.yyyy');
        /* Строковое представление даты для наименования колонки */
        SDATE_NAME := TO_CHAR(DDATE, SCOL_PATTERN_DATE);
        /* Описываем родительскую колонку таблицы данных */
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                                   SNAME      => 'N_' || SDATE_NAME || '_VALUE',
                                                   SCAPTION   => LPAD(D_DAY(DDATE), 2, '0'),
                                                   SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                                   SPARENT    => 'NVALUE_BY_DAYS');
        /* Описываем родительскую колонку таблицы данных */
        PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                                   SNAME      => 'N_' || SDATE_NAME || '_TYPE',
                                                   SCAPTION   => LPAD(D_DAY(DDATE), 2, '0'),
                                                   SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                                   BVISIBLE   => false,
                                                   SPARENT    => 'NVALUE_BY_DAYS');
        /* Добавляем день в коллекцию */
        TJOB_DAYS_ADD(TDAYS => TJOB_DAYS, DDATE => DDATE, NVALUE => null, NTYPE => 0);
      end loop;
    end DAYS_INIT;
    
    /* Заполнение нормы трудоемкости дней месяца */
    procedure DAYS_FILL
    (
      TDAYS                 in out nocopy TJOB_DAYS, -- Коллекци дней месяца
      DDATE                 in out date,             -- Начальный день строки СЗ
      DBEG_FACT             in date,                 -- Дата начала факт
      DDATE_TO              in date,                 -- Дата окончания месяца
      NLABOUR_FACT_FULL     in number,               -- Норма факт строки СЗ
      NLABOUR_PLAN_FULL     in number,               -- Норма план строки СЗ (с учетом нормы факт)
      NWORK_HOURS           in number                -- Количество рабочих часов смены
    )
    is
      NHOURS_LEFT           PKG_STD.TLNUMBER;        -- Количество оставшихся часов в дне
      NMAX_OF_DAY           PKG_STD.TQUANT;          -- Максимальное количество рабочих часов в дне
      NLABOUR_FACT          PKG_STD.TQUANT;          -- Оставшаяся трудоемкость факт
      NLABOUR_PLAN          PKG_STD.TQUANT;          -- Оставшаяся трудоемкость план
      NLABOUR_BY_DAY        PKG_STD.TQUANT;          -- Суммарная трудоемкость за день (в доли смены)
      NDAY_TYPE             PKG_STD.TNUMBER;         -- Тип дня (0 - выполняемый, 1 - выполненный)
      NINDEX                PKG_STD.TNUMBER;         -- Индекс даты в коллекции дат
    begin
      /* Указываем изначальные план и факт */
      NLABOUR_FACT := NLABOUR_FACT_FULL;
      NLABOUR_PLAN := NLABOUR_PLAN_FULL;
      /* Необходимо погасть факт и план */
      while (((NLABOUR_FACT <> 0) or (NLABOUR_PLAN <> 0)) and (DDATE <= DDATE_TO))
      loop
        /* Обнуляем трудоемкость в доли смены за день */
        NLABOUR_BY_DAY := 0;
        /* Считываем индекс коллеции текущего дня */
        NINDEX := TDAYS_INDEX_GET(TDAYS => TDAYS, DDATE => DDATE);
        /* Изначально всегда "Выполнено" */
        NDAY_TYPE := 1;
        /* Определяем количество оставшихся часов в дне */
        NHOURS_LEFT := (TRUNC(DDATE + 1) - DDATE) * 24;
        /* Если в текущем дне еще есть время */
        if (TDAYS(NINDEX).NVALUE <> 1) then
          /* Если день пустой */
          if (TDAYS(NINDEX).NVALUE = 0) then
            /* Определяем возможное указание часов (относительно оставшегося времени дня или часов в смене) */
            NMAX_OF_DAY := LEAST(NHOURS_LEFT, NWORK_HOURS);
          else
            /* Определяем количество оставшегося времени в дне */
            NMAX_OF_DAY := ((1 - TDAYS(NINDEX).NVALUE) * NWORK_HOURS);
            /* Определяем возможное указание часов (относительно оставшегося времени дня или заполненного времени дня) */
            NMAX_OF_DAY := LEAST(NHOURS_LEFT, NMAX_OF_DAY);
          end if;
          /* Если указана дата начала факт и осталась трудоемкость факт */
          if ((DBEG_FACT is not null) and (NLABOUR_FACT > 0)) then
            /* Если в данный день невозможно отметить весь факт */
            if (NLABOUR_FACT > NMAX_OF_DAY) then
              /* Вычитаем из суммарного факта трудоемкость дня */
              NLABOUR_FACT   := NLABOUR_FACT - NMAX_OF_DAY;
              NLABOUR_BY_DAY := NMAX_OF_DAY;
            else
              /* Добавляем трудоемкость факта и обнуляем суммарный факт */
              NLABOUR_BY_DAY := NLABOUR_BY_DAY + NLABOUR_FACT;
              NLABOUR_FACT   := 0;
            end if;
          end if;
          /* Если осталось время дня и есть план */
          if ((NMAX_OF_DAY > NLABOUR_BY_DAY) and (NLABOUR_PLAN > 0)) then
            /* Это день плана */
            NDAY_TYPE := 0;
            /* Если в данный день невозможно отметить всё */
            if (NLABOUR_PLAN > (NMAX_OF_DAY - NLABOUR_BY_DAY)) then
              /* Вычитаем из суммарного плана оставшуюсь часть дня */
              NLABOUR_PLAN   := NLABOUR_PLAN - (NMAX_OF_DAY - NLABOUR_BY_DAY);
              NLABOUR_BY_DAY := NMAX_OF_DAY;
            else
              /* Добавляем трудоемкость плана и обнуляем суммарный план */
              NLABOUR_BY_DAY := NLABOUR_BY_DAY + NLABOUR_PLAN;
              NLABOUR_PLAN   := 0;
            end if;
          end if;
          /* Если рабочего времени не осталось */
          if (NMAX_OF_DAY = 0) then
            /* Указываем целый день */
            TDAYS(NINDEX).NVALUE := 1;
          else
            /* Добавляем по текущему дню */
            TDAYS(NINDEX).NVALUE := TDAYS(NINDEX).NVALUE + (NLABOUR_BY_DAY / NWORK_HOURS);
          end if;
          /* Указываем тип дня */
          TDAYS(NINDEX).NTYPE := NDAY_TYPE;
        end if;
        /* Указываем следующий день */
        DDATE := TRUNC(DDATE + 1);
      end loop;
    end DAYS_FILL;
  begin
    /* Читем сортировки */
    RO := PKG_P8PANELS_VISUAL.TORDERS_FROM_XML(CORDERS => CORDERS);
    /* Преобразуем номер и размер страницы в номер строк с и по */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* Инициализируем таблицу данных */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE(BFIXED_HEADER => true, NFIXED_COLUMNS => 4);
    /* Описываем колонки таблицы данных */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => 'Рег. номер',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SSUBDIV',
                                               SCAPTION   => 'Участок',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BORDER     => true,
                                               NWIDTH     => 120);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SNAME',
                                               SCAPTION   => 'Станок',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               NWIDTH     => 240);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NLOAD',
                                               SCAPTION   => 'Загрузка (н/ч)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               NWIDTH     => 80);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NPROCENT_LOAD',
                                               SCAPTION   => 'Загрузка (%)',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               NWIDTH     => 80);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NVALUE_BY_DAYS',
                                               SCAPTION   => 'Загрузка в н/ч по дням месяца',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               SHINT      => 'Отображает сумму трудоемкости по дням месяца.<br><br>' ||
                                                             'Цвет значения отражает трудоемкость план/факт.<br>' ||
                                                             'Если дата месяца больше или равна текущей, то отображается трудоемкость "План", иначе "Факт":<br>' ||
                                                             'Черный - сумма трудоемкости "План";<br>' ||
                                                             '<b style="color:#0097ff">Голубой</b> -  сумма трудоемкости "Факт";<br>');
    /* Считываем первый и последний день месяца */
    P_FIRST_LAST_DAY(DCALCDATE => TO_DATE(SMONTH_YEAR, 'mm.yyyy'), DBGNDATE => DDATE_FROM, DENDDATE => DDATE_TO);
    /* Считываем единицу измерения нормочасов */
    FIND_DICMUNTS_CODE(NFLAG_SMART  => 0,
                       NFLAG_OPTION => 0,
                       NCOMPANY     => NCOMPANY,
                       SMEAS_MNEMO  => SDICMUNTS_WD,
                       NRN          => NDICMUNTS_WD);
    /* Считываем рег. номер рабочего календаря */
    NENPERIOD := ENPERIOD_GET(NCOMPANY => NCOMPANY, DDATE_FROM => DDATE_FROM, DDATE_TO => DDATE_TO);
    /* Инициализируем дни месяца */
    DAYS_INIT(RDG => RDG, TJOB_DAYS => TDAYS, DDATE_FROM => DDATE_FROM, DDATE_TO => DDATE_TO);
    /* Определяем текущий день */
    DCURRENT_DAY := TRUNC(sysdate);
    /* Если параметры указаны */
    if ((NSUBDIV is not null) and (SMONTH_YEAR is not null)) then
      /* Обходим данные */
      begin
        /* Добавляем подсказку совместимости */
        CSQL := PKG_SQL_BUILD.COMPATIBLE(SSQL => CSQL);
        /* Формируем запрос */
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => 'select *');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '  from (select D.*,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => PKG_SQL_BUILD.SQLROWNUM() || ' NROW');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '          from (select TMP.*');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                  from (select IQ.RN NRN,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               IQ."NAME" SNAME,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               I.CODE SSUBDIV,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               COALESCE((select SUM(F_DICMUNTS_BASE_RECALC_QUANT(0,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                                                 T.COMPANY,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                                                 JS.MUNIT,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                                                 case');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                                                   when (TRUNC(JS.BEG_PLAN) >= :DSYSDATE) then');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                                                     JS.LABOUR_PLAN');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                                                   when (JS.BEG_FACT < :DSYSDATE) then');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                                                     JS.LABOUR_FACT');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                                                   else');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                                                     0');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                                                 end,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                                                 :NDICMUNTS))');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                           from FCJOBSSP JS,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                FCJOBS T');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                          where JS.EQCONFIG = IQ.RN');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                            and JS.COMPANY = :NCOMPANY');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                            and T.RN = JS.PRN');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                            and T.DOCDATE >= :DDATE_FROM');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                            and T.DOCDATE <= :DDATE_TO');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                            and (((TRUNC(JS.BEG_PLAN) >= :DSYSDATE) and (TRUNC(JS.BEG_PLAN) <= :DDATE_TO))');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                              or ((JS.BEG_FACT < :DSYSDATE) and (TRUNC(JS.BEG_FACT) between :DDATE_FROM and :DDATE_TO)))');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                            and ' || PKG_SQL_BUILD.PKG_NAME(SNAME => 'PKG_P8PANELS_MECHREC.UTL_SUBDIV_HIER_CHECK') || '(T.COMPANY, T.SUBDIV, :SUTILIZER, :NSUBDIV) = ' || PKG_SQL_BUILD.WRAP_NUM(NVALUE => 1));
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                            and exists (select null from V_USERPRIV UP where UP."CATALOG" = T.CRN)), 0) NLOAD');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                          from INS_DEPARTMENT I,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               SUBDIVSEQ      HEQ,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                               EQCONFIG       IQ');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                         where I.RN in (' || PKG_SQL_BUILD.CONNECT_BY(STABLE_NAME    => 'INS_DEPARTMENT', 
                                                                                                                               STABLE_ALIAS   => 'H', 
                                                                                                                               SSELECT_CLAUSE => 'RN', 
                                                                                                                               SWHERE_CLAUSE  => 'COMPANY = ' || NCOMPANY, 
                                                                                                                               SSTART_CLAUSE  => 'RN = ' || NSUBDIV, 
                                                                                                                               SPRIOR_COLUMN  => 'RN', 
                                                                                                                               SREF_COLUMN    => 'PRN') || ')');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and HEQ.PRN = I.RN');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and IQ.RN = HEQ.EQCONFIG');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and IQ.OPER_DATE is not null');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                           and IQ.OPER_DATE <= :DDATE_TO');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                         group by IQ.RN,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  IQ."NAME",');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  I.CODE');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                         %ORDER_BY%) TMP');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '               ) D) F');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => ' where F.NROW between :NROW_FROM and :NROW_TO');
        /* Учтём сортировки */
        PKG_P8PANELS_VISUAL.TORDERS_SET_QUERY(RDATA_GRID => RDG, RORDERS => RO, SPATTERN => '%ORDER_BY%', CSQL => CSQL);
        /* Разбираем его */
        ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
        PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
        /* Делаем подстановку параметров */
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NCOMPANY', NVALUE => NCOMPANY);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
        PKG_SQL_DML.BIND_VARIABLE_DATE(ICURSOR => ICURSOR, SNAME => 'DDATE_FROM', DVALUE => DDATE_FROM);
        PKG_SQL_DML.BIND_VARIABLE_DATE(ICURSOR => ICURSOR, SNAME => 'DDATE_TO', DVALUE => DDATE_TO);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NDICMUNTS', NVALUE => NDICMUNTS_WD);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NSUBDIV', NVALUE => NSUBDIV);
        PKG_SQL_DML.BIND_VARIABLE_DATE(ICURSOR => ICURSOR, SNAME => 'DSYSDATE', DVALUE => DCURRENT_DAY);
        PKG_SQL_DML.BIND_VARIABLE_STR(ICURSOR => ICURSOR, SNAME => 'SUTILIZER', SVALUE => SUTILIZER);
        /* Описываем структуру записи курсора */
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 1);
        PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 2);
        PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 3);
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 4);
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 5);
        /* Делаем выборку */
        if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
          null;
        end if;
        /* Обходим выбранные записи */
        while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
        loop
          /* Считываем рег. номер станка */
          PKG_SQL_DML.COLUMN_VALUE_NUM(ICURSOR => ICURSOR, IPOSITION => 1, NVALUE => NEQCONFIG);
          /* Добавляем колонки с данными */
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NRN', NVALUE => NEQCONFIG, BCLEAR => true);
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW => RDG_ROW, SNAME => 'SNAME', ICURSOR => ICURSOR, NPOSITION => 2);
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                                SNAME     => 'SSUBDIV',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 3);
          /* Считываем загрузку в нормочасах */
          PKG_SQL_DML.COLUMN_VALUE_NUM(ICURSOR => ICURSOR, IPOSITION => 4, NVALUE => NLOAD);
          /* Округляем загрузку */
          NLOAD := ROUND(NLOAD, 3);
          /* Если количество рабочих часов не 0 */
          if ((NWORKHOURS is not null) and (NWORKHOURS <> 0)) then
            /* Рассчитываем загрузку в % */
            NPROCENT_LOAD := ROUND(NLOAD / NWORKHOURS * 100, 1);
          else
            /* Устанавливаем 0 */
            NPROCENT_LOAD := 0;
          end if;
          /* Устанавливаем загрузку */
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NLOAD', NVALUE => NLOAD);
          PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW => RDG_ROW, SNAME => 'NPROCENT_LOAD', NVALUE => NPROCENT_LOAD);
          /* Если у оборудования есть загрузка */
          if (NLOAD <> 0) then
            /* Обходим загруженность по дням */
            for REC in (select TMP.BEG_DATE DBEG_DATE,
                               sum(TMP.LABOUR_PLAN) NLABOUR_PLAN,
                               sum(TMP.LABOUR_FACT) NLABOUR_FACT
                          from (select case
                                         when ((T.BEG_FACT is not null) and (TRUNC(T.BEG_FACT) < sysdate)) then
                                          TRUNC(T.BEG_FACT)
                                         else
                                          TRUNC(T.BEG_PLAN)
                                       end BEG_DATE,
                                       F_DICMUNTS_BASE_RECALC_QUANT(0, T.COMPANY, T.MUNIT, T.LABOUR_PLAN, NDICMUNTS_WD) LABOUR_PLAN,
                                       F_DICMUNTS_BASE_RECALC_QUANT(0, T.COMPANY, T.MUNIT, T.LABOUR_FACT, NDICMUNTS_WD) LABOUR_FACT
                                  from FCJOBSSP T,
                                       FCJOBS   J
                                 where T.COMPANY = NCOMPANY
                                   and J.RN = T.PRN
                                   and (((T.BEG_FACT < DCURRENT_DAY) and
                                       (TRUNC(T.BEG_FACT) between DDATE_FROM and DDATE_TO)) or
                                       ((TRUNC(T.BEG_PLAN) >= DCURRENT_DAY) and (TRUNC(T.BEG_PLAN) <= DDATE_TO)))
                                   and PKG_P8PANELS_MECHREC.UTL_SUBDIV_HIER_CHECK(J.COMPANY, J.SUBDIV, SUTILIZER, NSUBDIV) = 1
                                   and T.EQCONFIG = NEQCONFIG
                                 order by T.BEG_FACT) TMP
                         where ((TMP.BEG_DATE < DCURRENT_DAY) and (TMP.LABOUR_FACT <> 0))
                            or ((TMP.BEG_DATE >= DCURRENT_DAY) and (TMP.LABOUR_PLAN <> 0))
                         group by TMP.BEG_DATE
                         order by TMP.BEG_DATE)
            loop
              /* Считываем индекс коллеции текущего дня */
              NINDEX := TDAYS_INDEX_GET(TDAYS => TDAYS, DDATE => REC.DBEG_DATE);
              /* Если день до текущего */
              if (REC.DBEG_DATE < DCURRENT_DAY) then
                /* Отмечаем трудоемкость факт */
                TDAYS(NINDEX).NVALUE := REC.NLABOUR_FACT;
              else
                /* Отмечаем трудоемкость план */
                TDAYS(NINDEX).NVALUE := REC.NLABOUR_PLAN;
              end if;
            end loop;
            /* Обходим все дни */
            for I in TDAYS.FIRST .. TDAYS.LAST
            loop
              /* Отмечаем значение дня */
              PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW   => RDG_ROW,
                                               SNAME  => 'N_' || TO_CHAR(TDAYS(I).DDATE, SCOL_PATTERN_DATE) || '_VALUE',
                                               NVALUE => ROUND(TDAYS(I).NVALUE, 1));
              /* Если рабочий календарь считан */
              if (NENPERIOD is not null) then
                /* Отмечаем тип дня */
                PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW   => RDG_ROW,
                                                 SNAME  => 'N_' || TO_CHAR(TDAYS(I).DDATE, SCOL_PATTERN_DATE) || '_TYPE',
                                                 NVALUE => DAY_TYPE_GET(NENPERIOD    => NENPERIOD,
                                                                        DDATE        => TDAYS(I).DDATE,
                                                                        DCURRENT_DAY => DCURRENT_DAY));
              end if;
              /* Обнуляем значение */
              TDAYS(I).NVALUE := null;
            end loop;
          else
            /* Обходим все дни */
            for I in TDAYS.FIRST .. TDAYS.LAST
            loop
              /* Отмечаем значение дня */
              PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW   => RDG_ROW,
                                               SNAME  => 'N_' || TO_CHAR(TDAYS(I).DDATE, SCOL_PATTERN_DATE) || '_VALUE',
                                               NVALUE => null);
              /* Если рабочий календарь считан */
              if (NENPERIOD is not null) then
                /* Отмечаем тип дня */
                PKG_P8PANELS_VISUAL.TROW_ADD_COL(RROW   => RDG_ROW,
                                                 SNAME  => 'N_' || TO_CHAR(TDAYS(I).DDATE, SCOL_PATTERN_DATE) || '_TYPE',
                                                 NVALUE => DAY_TYPE_GET(NENPERIOD    => NENPERIOD,
                                                                        DDATE        => TDAYS(I).DDATE,
                                                                        DCURRENT_DAY => DCURRENT_DAY));
              end if;
            end loop;
          end if;
          /* Добавляем строку в таблицу */
          PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
        end loop;
      exception
        when others then
          PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
          raise;
      end;
    end if;
    /* Сериализуем описание */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  end FCJOBS_DEP_LOAD_DG_GET;
  
  /*
    Процедуры панели "Мониторинг сборки изделий"
  */
  
  /* Получение таблицы маршрутных листов связанной записи "Производственная программа" */
  procedure FCROUTLST_DG_BY_LINKED_GET
  (
    NFCPRODPLANSP           in number,                             -- Рег. номер связанной строки плана
    NPAGE_NUMBER            in number,                             -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- Количество записей на странице (0 - все)
    CORDERS                 in clob,                               -- Сортировки
    NINCLUDE_DEF            in number,                             -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob                               -- Сериализованная таблица данных
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    RO                      PKG_P8PANELS_VISUAL.TORDERS;           -- Сортировки
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- Описание таблицы
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы
    NROW_FROM               PKG_STD.TREF;                          -- Номер строки с
    NROW_TO                 PKG_STD.TREF;                          -- Номер строки по
    CSQL                    clob;                                  -- Буфер для запроса
    ICURSOR                 integer;                               -- Курсор для исполнения запроса
    NFCROUTLST_IDENT        PKG_STD.TREF;                          -- Рег. номер идентификатора отмеченных записей маршрутных листов
    NDICMUNTS_WD            PKG_STD.TREF;                          -- Рег. номер ед. измерения нормочасов
  begin
    /* Читем сортировки */
    RO := PKG_P8PANELS_VISUAL.TORDERS_FROM_XML(CORDERS => CORDERS);
    /* Преобразуем номер и размер страницы в номер строк с и по */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* Инициализируем таблицу данных */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE();
    /* Описываем колонки таблицы данных */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => 'Рег. номер',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SNUMB',
                                               SCAPTION   => '% п/п',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SOPERATION',
                                               SCAPTION   => 'Содержание работ',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SEXECUTOR',
                                               SCAPTION   => 'Исполнитель',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NREMN_LABOUR',
                                               SCAPTION   => 'Остаточная трудоемкость, в н/ч',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true);
    /* Если спецификация считалась */
    if (NFCPRODPLANSP is not null) then
      /* Инициализируем список маршрутных листов */
      UTL_FCROUTLST_IDENT_INIT(NFCPRODPLANSP => NFCPRODPLANSP, NIDENT => NFCROUTLST_IDENT);
      /* Считываем единицу измерения нормочасов */
      FIND_DICMUNTS_CODE(NFLAG_SMART  => 0,
                         NFLAG_OPTION => 0,
                         NCOMPANY     => NCOMPANY,
                         SMEAS_MNEMO  => SDICMUNTS_WD,
                         NRN          => NDICMUNTS_WD);
      begin
        /* Добавляем подсказку совместимости */
        CSQL := PKG_SQL_BUILD.COMPATIBLE(SSQL => CSQL);
        /* Формируем запрос */
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => 'select *');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '  from (select D.*,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => PKG_SQL_BUILD.SQLROWNUM() || ' NROW');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '          from (select SF.RN NRN,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       TRIM(SH.NUMB) SNUMB,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       COALESCE(SH.OPER_UK, FT."NAME") SOPERATION,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       (select I.CODE from INS_DEPARTMENT I where SF.SUBDIV = I.RN) SEXECUTOR,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       ROUND(F_DICMUNTS_BASE_RECALC_QUANT(' || PKG_SQL_BUILD.WRAP_NUM(NVALUE => 0) || ',');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                          :NCOMPANY,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                          SF.MUNIT,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                          SF.T_SHT_PLAN - SF.LABOUR_FACT,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                                          :NDICMUNTS_WD), 3) NREMN_LABOUR'); 
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                  from FCROUTLST F,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       FCROUTLSTSP SF,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       FCROUTSHTSP SH left outer join FCOPERTYPES FT on SH.OPER_TPS = FT.RN');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                 where F.RN in (select SL."DOCUMENT"');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                  from SELECTLIST SL');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                 where SL.IDENT    = :NFCROUTLST_IDENT');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                                   and SL.UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostRouteLists') || ')');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and SF.PRN = F.RN');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and SH.RN = SF.FCROUTSHTSP');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and F.COMPANY = :NCOMPANY');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                %ORDER_BY%) D) F');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => ' where F.NROW between :NROW_FROM and :NROW_TO');
        /* Учтём сортировки */
        PKG_P8PANELS_VISUAL.TORDERS_SET_QUERY(RDATA_GRID => RDG, RORDERS => RO, SPATTERN => '%ORDER_BY%', CSQL => CSQL);
        /* Разбираем его */
        ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
        PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
        /* Делаем подстановку параметров */
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NCOMPANY', NVALUE => NCOMPANY);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NDICMUNTS_WD', NVALUE => NDICMUNTS_WD);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NFCROUTLST_IDENT', NVALUE => NFCROUTLST_IDENT);
        /* Описываем структуру записи курсора */
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 1);
        PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 2);
        PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 3);
        PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 4);
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 5);
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 6);
        /* Делаем выборку */
        if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
          null;
        end if;
        /* Обходим выбранные записи */
        while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
        loop
          /* Добавляем колонки с данными */
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                                SNAME     => 'NRN',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 1,
                                                BCLEAR    => true);
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                                SNAME     => 'SNUMB',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 2);
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                                SNAME     => 'SOPERATION',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 3);
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                                SNAME     => 'SEXECUTOR',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 4);
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                                SNAME     => 'NREMN_LABOUR',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 5);
          /* Добавляем строку в таблицу */
          PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
        end loop;
      exception
        when others then
          PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
          raise;
      end;
    end if;
    /* Очищаем отмеченные маршрутные листы */
    P_SELECTLIST_CLEAR(NIDENT => NFCROUTLST_IDENT);
    /* Сериализуем описание */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  exception
    when others then
      /* Очищаем отмеченные маршрутные листы */
      P_SELECTLIST_CLEAR(NIDENT => NFCROUTLST_IDENT);
      raise;
  end FCROUTLST_DG_BY_LINKED_GET;
  
  /* Получение таблицы комплектовочных ведомостей связанной записи "Производственная программа" */
  procedure FCDELIVSH_DG_BY_LINKED_GET
  (
    NFCPRODPLANSP           in number,                             -- Рег. номер связанной строки плана
    NPAGE_NUMBER            in number,                             -- Номер страницы (игнорируется при NPAGE_SIZE=0)
    NPAGE_SIZE              in number,                             -- Количество записей на странице (0 - все)
    CORDERS                 in clob,                               -- Сортировки
    NINCLUDE_DEF            in number,                             -- Признак включения описания колонок таблицы в ответ
    COUT                    out clob                               -- Сериализованная таблица данных
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    RO                      PKG_P8PANELS_VISUAL.TORDERS;           -- Сортировки
    RDG                     PKG_P8PANELS_VISUAL.TDATA_GRID;        -- Описание таблицы
    RDG_ROW                 PKG_P8PANELS_VISUAL.TROW;              -- Строка таблицы
    NROW_FROM               PKG_STD.TREF;                          -- Номер строки с
    NROW_TO                 PKG_STD.TREF;                          -- Номер строки по
    CSQL                    clob;                                  -- Буфер для запроса
    ICURSOR                 integer;                               -- Курсор для исполнения запроса
  begin
    /* Читем сортировки */
    RO := PKG_P8PANELS_VISUAL.TORDERS_FROM_XML(CORDERS => CORDERS);
    /* Преобразуем номер и размер страницы в номер строк с и по */
    PKG_P8PANELS_VISUAL.UTL_ROWS_LIMITS_CALC(NPAGE_NUMBER => NPAGE_NUMBER,
                                             NPAGE_SIZE   => NPAGE_SIZE,
                                             NROW_FROM    => NROW_FROM,
                                             NROW_TO      => NROW_TO);
    /* Инициализируем таблицу данных */
    RDG := PKG_P8PANELS_VISUAL.TDATA_GRID_MAKE();
    /* Описываем колонки таблицы данных */
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NRN',
                                               SCAPTION   => 'Рег. номер',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => false);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SNOMEN',
                                               SCAPTION   => 'Номенклатура',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NQUANT_PLAN',
                                               SCAPTION   => 'Применяемость',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'SPROVIDER',
                                               SCAPTION   => 'Поставщик',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_STR,
                                               BVISIBLE   => true);
    PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_COL_DEF(RDATA_GRID => RDG,
                                               SNAME      => 'NDEFICIT',
                                               SCAPTION   => 'Дефицит',
                                               SDATA_TYPE => PKG_P8PANELS_VISUAL.SDATA_TYPE_NUMB,
                                               BVISIBLE   => true);
    /* Если спецификация считалась */
    if (NFCPRODPLANSP is not null) then
      begin
        /* Добавляем подсказку совместимости */
        CSQL := PKG_SQL_BUILD.COMPATIBLE(SSQL => CSQL);
        /* Формируем запрос */
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => 'select *');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '  from (select D.*,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => PKG_SQL_BUILD.SQLROWNUM() || ' NROW');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '          from (select T.RN NRN,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       NM.NOMEN_NAME SNOMEN,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.QUANT_PLAN NQUANT_PLAN,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       (select I2.CODE from INS_DEPARTMENT I2 where T.PR_SUBDIV = I2.RN) SPROVIDER,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       T.DEFICIT NDEFICIT');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                  from DOCLINKS D,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       FCDELIVSHSP T,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       FCMATRESOURCE F,');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                       DICNOMNS NM');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                 where D.IN_DOCUMENT = :NFCPRODPLANSP');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and D.IN_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostProductPlansSpecs'));
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and D.OUT_UNITCODE = ' || PKG_SQL_BUILD.WRAP_STR(SVALUE => 'CostDeliverySheets'));
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.PRN = D.OUT_DOCUMENT');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.COMPANY = :NCOMPANY');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.MATRES = F.RN');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and F.NOMENCLATURE = NM.RN');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                   and T.DEFICIT > ' || PKG_SQL_BUILD.WRAP_NUM(NVALUE => 0));
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => '                %ORDER_BY%) D) F');
        PKG_SQL_BUILD.APPEND(SSQL => CSQL, SELEMENT1 => ' where F.NROW between :NROW_FROM and :NROW_TO');
        /* Учтём сортировки */
        PKG_P8PANELS_VISUAL.TORDERS_SET_QUERY(RDATA_GRID => RDG, RORDERS => RO, SPATTERN => '%ORDER_BY%', CSQL => CSQL);
        /* Разбираем его */
        ICURSOR := PKG_SQL_DML.OPEN_CURSOR(SWHAT => 'SELECT');
        PKG_SQL_DML.PARSE(ICURSOR => ICURSOR, SQUERY => CSQL);
        /* Делаем подстановку параметров */
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NCOMPANY', NVALUE => NCOMPANY);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_FROM', NVALUE => NROW_FROM);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NROW_TO', NVALUE => NROW_TO);
        PKG_SQL_DML.BIND_VARIABLE_NUM(ICURSOR => ICURSOR, SNAME => 'NFCPRODPLANSP', NVALUE => NFCPRODPLANSP);
        /* Описываем структуру записи курсора */
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 1);
        PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 2);
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 3);
        PKG_SQL_DML.DEFINE_COLUMN_STR(ICURSOR => ICURSOR, IPOSITION => 4);
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 5);
        PKG_SQL_DML.DEFINE_COLUMN_NUM(ICURSOR => ICURSOR, IPOSITION => 6);
        /* Делаем выборку */
        if (PKG_SQL_DML.EXECUTE(ICURSOR => ICURSOR) = 0) then
          null;
        end if;
        /* Обходим выбранные записи */
        while (PKG_SQL_DML.FETCH_ROWS(ICURSOR => ICURSOR) > 0)
        loop
          /* Добавляем колонки с данными */
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                                SNAME     => 'NRN',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 1,
                                                BCLEAR    => true);
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                                SNAME     => 'SNOMEN',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 2);
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                                SNAME     => 'NQUANT_PLAN',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 3);
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLS(RROW      => RDG_ROW,
                                                SNAME     => 'SPROVIDER',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 4);
          PKG_P8PANELS_VISUAL.TROW_ADD_CUR_COLN(RROW      => RDG_ROW,
                                                SNAME     => 'NDEFICIT',
                                                ICURSOR   => ICURSOR,
                                                NPOSITION => 5);
          /* Добавляем строку в таблицу */
          PKG_P8PANELS_VISUAL.TDATA_GRID_ADD_ROW(RDATA_GRID => RDG, RROW => RDG_ROW);
        end loop;
      exception
        when others then
          PKG_SQL_DML.CLOSE_CURSOR(ICURSOR => ICURSOR);
          raise;
      end;
    end if;
    /* Сериализуем описание */
    COUT := PKG_P8PANELS_VISUAL.TDATA_GRID_TO_XML(RDATA_GRID => RDG, NINCLUDE_DEF => NINCLUDE_DEF);
  end FCDELIVSH_DG_BY_LINKED_GET;
  
  /* Получение изображения для записи "Планы и отчеты производства изделий" по мат. ресурсу */
  function FCMATRESOURCE_IMAGE_GET
  (
    NRN                     in number,  -- Рег. номер записи материального ресурса
    SFLINKTYPE              in varchar2 -- Код типа присоединённого документа изображения (см. константы SFLINKTYPE_*)
  ) return                  blob        -- Данные считанного изображения (null - если ничего не найдено)
  is
  begin
    /* Найдем изображение */
    for IMG in (select M.BDATA
                  from FILELINKS      M,
                       FILELINKSUNITS U,
                       FLINKTYPES     FLT
                 where M.FILE_TYPE = FLT.RN
                   and FLT.CODE = SFLINKTYPE
                   and U.TABLE_PRN = NRN
                   and U.UNITCODE = 'CostMaterialResources'
                   and M.RN = U.FILELINKS_PRN
                   and M.BDATA is not null
                   and ROWNUM = 1)
    loop
      /* Вернём его */
      return IMG.BDATA;
    end loop;
    /* Ничего не нашли */
    return null;
  end FCMATRESOURCE_IMAGE_GET;
  
  /* Получение таблицы записей "Планы и отчеты производства изделий" */
  procedure FCPRODPLAN_GET
  (
    NCRN                    in number,        -- Рег. номер каталога
    COUT                    out clob          -- Сериализованная таблица данных
  )
  is
    NPROGRESS               PKG_STD.TLNUMBER; -- Прогресс плана
    
    /* Получение номера плана из заказа */
    function NUMB_BY_PROD_ORDER_GET
    (
      SPROD_ORDER           in varchar2 -- Заказ
    ) return                varchar2    -- Номер плана
    is
    begin
      /* Возвращаем результат */
      return trim(SUBSTR(SPROD_ORDER, LENGTH(SPROD_ORDER)-2));
    end NUMB_BY_PROD_ORDER_GET;
    
    /* Получение детализации по прогрессу */
    function DETAIL_BY_PROGRESS_GET
    (
      NPROGRESS             in number        -- Прогресс
    ) return                varchar2         -- Детализация по прогрессу
    is
      SRESULT               PKG_STD.TSTRING; -- Детализация по прогрессу
    begin
      /* Определяем детализацию по прогрессу */
      case
        when (NPROGRESS >= 70) then
          SRESULT := 'Основная сборка: Стыковка агрегатов выполнена';
        when (NPROGRESS >= 40) then
          SRESULT := 'Изготовление агрегатов: Фюзеляж и ОЧК не переданы в цех ОС';
        when (NPROGRESS >= 10) then
          SRESULT := 'Изготовление ДСЕ: Фюзеляж и ОЧК не укомлектованы ДСЕ';
        else
          SRESULT := 'Изготовление ДСЕ не начато';
      end case;
      /* Возвращаем результат */
      return SRESULT;
    end DETAIL_BY_PROGRESS_GET;
  begin
    /* Начинаем формирование XML */
    PKG_XFAST.PROLOGUE(ITYPE => PKG_XFAST.CONTENT_);
    /* Открываем корень */
    PKG_XFAST.DOWN_NODE(SNAME => 'XDATA');
    /* Цикл по планам и отчетам производства изделий */
    for REC in (select SP.RN NRN,
                       SP.MATRES NMATRES,
                       (select trim(PORD.NUMB) from FACEACC PORD where PORD.RN = SP.PROD_ORDER) SPROD_ORDER,
                       D_YEAR(SP.REP_DATE_TO) NYEAR,
                       COALESCE(SP.LABOUR_FACT, 0) NLABOUR_FACT,
                       COALESCE(SP.LABOUR_PLAN, 0) NLABOUR_PLAN
                  from FCPRODPLAN P
                  left outer join FCPRODPLANSP SP
                    on P.RN = SP.PRN
                   and ((SP.LABOUR_PLAN is not null) or (SP.LABOUR_FACT is not null)), FINSTATE FS, ENPERIOD EN
                 where P.CRN = NCRN
                   and P.CATEGORY = NFCPRODPLAN_CATEGORY_MON
                   and P.STATUS = NFCPRODPLAN_STATUS_MON
                   and FS.RN = P.TYPE
                   and FS.CODE = SFCPRODPLAN_TYPE_MON
                   and EN.RN = P.CALC_PERIOD
                   and exists (select /*+ INDEX(UP I_USERPRIV_JUR_PERS_ROLEID) */
                         null
                          from USERPRIV UP
                         where UP.JUR_PERS = P.JUR_PERS
                           and UP.UNITCODE = 'CostProductPlans'
                           and UP.ROLEID in (select /*+ INDEX(UR I_USERROLES_AUTHID_FK) */
                                              UR.ROLEID
                                               from USERROLES UR
                                              where UR.AUTHID = UTILIZER())
                        union all
                        select /*+ INDEX(UP I_USERPRIV_JUR_PERS_AUTHID) */
                         null
                          from USERPRIV UP
                         where UP.JUR_PERS = P.JUR_PERS
                           and UP.UNITCODE = 'CostProductPlans'
                           and UP.AUTHID = UTILIZER())
                 order by SP.REP_DATE_TO asc)
    loop
      /* Открываем план */
      PKG_XFAST.DOWN_NODE(SNAME => 'XFCPRODPLAN_INFO');
      /* Описываем план */
      PKG_XFAST.ATTR(SNAME => 'NRN', NVALUE => REC.NRN);
      PKG_XFAST.ATTR(SNAME => 'SNUMB', SVALUE => NUMB_BY_PROD_ORDER_GET(SPROD_ORDER => REC.SPROD_ORDER));
      /* Определяем прогресс */
      if (REC.NLABOUR_PLAN = 0) then
        /* Не можем определить прогресс */
        NPROGRESS := 0;
      else
        /* Если факта нет */
        if (REC.NLABOUR_FACT = 0) then
          /* Не можем определить прогресс */
          NPROGRESS := 0;
        else
          /* Определим прогресс */
          NPROGRESS := ROUND(REC.NLABOUR_FACT / REC.NLABOUR_PLAN * 100, 2);
        end if;
      end if;
      PKG_XFAST.ATTR(SNAME => 'NPROGRESS', NVALUE => NPROGRESS);
      PKG_XFAST.ATTR(SNAME => 'SDETAIL', SVALUE => DETAIL_BY_PROGRESS_GET(NPROGRESS => NPROGRESS));
      PKG_XFAST.ATTR(SNAME => 'NYEAR', NVALUE => REC.NYEAR);
      PKG_XFAST.DOWN_NODE(SNAME => 'BIMAGE');
      PKG_XFAST.VALUE(LBVALUE => FCMATRESOURCE_IMAGE_GET(NRN => REC.NMATRES, SFLINKTYPE => SFLINKTYPE_PREVIEW));
      PKG_XFAST.UP();
      /* Закрываем план */
      PKG_XFAST.UP();
    end loop;
    /* Закрываем корень */
    PKG_XFAST.UP();
    /* Сериализуем */
    COUT := PKG_XFAST.SERIALIZE_TO_CLOB();
    /* Завершаем формирование XML */
    PKG_XFAST.EPILOGUE();
  exception
    when others then
      /* Завершаем формирование XML */
      PKG_XFAST.EPILOGUE();
      /* Вернем ошибку */
      PKG_STATE.DIAGNOSTICS_STACKED();
      P_EXCEPTION(0, PKG_STATE.SQL_ERRM());
  end FCPRODPLAN_GET;
  
  /* Инициализация каталогов раздела "Планы и отчеты производства изделий" для панели "Мониторинг сборки изделий"  */
  procedure FCPRODPLAN_AM_CTLG_INIT
  (
    COUT                    out clob    -- Список каталогов раздела "Планы и отчеты производства изделий"
  )
  is
  begin
    /* Начинаем формирование XML */
    PKG_XFAST.PROLOGUE(ITYPE => PKG_XFAST.CONTENT_);
    /* Открываем корень */
    PKG_XFAST.DOWN_NODE(SNAME => 'XDATA');
    /* Цикл по планам и отчетам производства изделий */
    for REC in (select TMP.NRN,
                       TMP.SNAME,
                       count(P.RN) NCOUNT_DOCS,
                       min(D_YEAR(ENP.STARTDATE)) NMIN_YEAR,
                       max(D_YEAR(ENP.ENDDATE)) NMAX_YEAR
                  from (select T.RN   as NRN,
                               T.NAME as SNAME
                          from ACATALOG T,
                               UNITLIST UL
                         where T.DOCNAME = 'CostProductPlans'
                           and T.COMPANY = GET_SESSION_COMPANY()
                           and T.SIGNS = 1
                           and T.DOCNAME = UL.UNITCODE
                           and (UL.SHOW_INACCESS_CTLG = 1 or exists
                                (select null from V_USERPRIV UP where UP.CATALOG = T.RN) or exists
                                (select null
                                   from ACATALOG T1
                                  where exists (select null from V_USERPRIV UP where UP.CATALOG = T1.RN)
                                 connect by prior T1.RN = T1.CRN
                                  start with T1.CRN = T.RN))
                         order by T.NAME asc) TMP
                  left outer join FCPRODPLAN P
                    on TMP.NRN = P.CRN
                   and P.CATEGORY = NFCPRODPLAN_CATEGORY_MON
                   and P.STATUS = NFCPRODPLAN_STATUS_MON
                   and P.COMPANY = GET_SESSION_COMPANY()
                   and exists (select /*+ INDEX(UP I_USERPRIV_JUR_PERS_ROLEID) */
                         null
                          from USERPRIV UP
                         where UP.JUR_PERS = P.JUR_PERS
                           and UP.UNITCODE = 'CostProductPlans'
                           and UP.ROLEID in (select /*+ INDEX(UR I_USERROLES_AUTHID_FK) */
                                              UR.ROLEID
                                               from USERROLES UR
                                              where UR.AUTHID = UTILIZER())
                        union all
                        select /*+ INDEX(UP I_USERPRIV_JUR_PERS_AUTHID) */
                         null
                          from USERPRIV UP
                         where UP.JUR_PERS = P.JUR_PERS
                           and UP.UNITCODE = 'CostProductPlans'
                           and UP.AUTHID = UTILIZER())
                  left outer join FINSTATE FS
                    on P.TYPE = FS.RN
                   and FS.CODE = SFCPRODPLAN_TYPE_MON
                  left join ENPERIOD ENP
                    on P.CALC_PERIOD = ENP.RN
                 group by TMP.NRN,
                          TMP.SNAME
                 order by TMP.SNAME asc)
    loop
      /* Открываем план */
      PKG_XFAST.DOWN_NODE(SNAME => 'XFCPRODPLAN_CRNS');
      /* Описываем план */
      PKG_XFAST.ATTR(SNAME => 'NRN', NVALUE => REC.NRN);
      PKG_XFAST.ATTR(SNAME => 'SNAME', SVALUE => REC.SNAME);
      PKG_XFAST.ATTR(SNAME => 'NCOUNT_DOCS', NVALUE => REC.NCOUNT_DOCS);
      PKG_XFAST.ATTR(SNAME => 'NMIN_YEAR', NVALUE => REC.NMIN_YEAR);
      PKG_XFAST.ATTR(SNAME => 'NMAX_YEAR', NVALUE => REC.NMAX_YEAR);
      /* Закрываем план */
      PKG_XFAST.UP();
    end loop;
    /* Закрываем корень */
    PKG_XFAST.UP();
    /* Сериализуем */
    COUT := PKG_XFAST.SERIALIZE_TO_CLOB();
    /* Завершаем формирование XML */
    PKG_XFAST.EPILOGUE();
  exception
    when others then
      /* Завершаем формирование XML */
      PKG_XFAST.EPILOGUE();
      /* Вернем ошибку */
      PKG_STATE.DIAGNOSTICS_STACKED();
      P_EXCEPTION(0, PKG_STATE.SQL_ERRM());
  end FCPRODPLAN_AM_CTLG_INIT;

  /* Считывание деталей производственного состава */
  procedure FCPRODCMP_DETAILS_GET
  (
    NFCPRODPLANSP           in number,                             -- Рег. номер строки плана
    COUT                    out clob                               -- Сериализованная таблица данных
  )
  is
    NCOMPANY                PKG_STD.TREF := GET_SESSION_COMPANY(); -- Организация сеанса
    NDP_MODEL_ID            PKG_STD.TREF;                          -- Рег. номер свойства "Идентификатор в SVG-модели"
    NDP_MODEL_BG_COLOR      PKG_STD.TREF;                          -- Рег. номер свойства "Цвет заливки в SVG-модели"
    NFCPRODPLANSP_LINKED    PKG_STD.TREF;                          -- Рег. номер связанной спецификации плана
    
    /* Функция получения материального ресурса строки плана */
    function FCPRODPLANSP_MATRES_GET
    (
      NFCPRODPLANSP         in number     -- Рег. номер строки плана
    ) return                number        -- Рег. номер мат. ресурса
    is
      NRESULT               PKG_STD.TREF; -- Рег. номер мат. ресурса
    begin
      /* Считываем рег. номер мат. ресурса */
      begin
        select T.MATRES into NRESULT from FCPRODPLANSP T where T.RN = NFCPRODPLANSP;
      exception
        when others then
          NRESULT := null;
      end;
      /* Возвращаем результат */
      return NRESULT;
    end FCPRODPLANSP_MATRES_GET;
    
    /* Считывание рег. номера спецификации связанного плана */
    function FCPRODPLANSP_LINKED_GET
    (
      NPRODCMPSP              in number,    -- Рег. номер производственного состава
      NFCPRODPLANSP           in number     -- Рег. номер строки плана
    ) return                  number        -- Рег. номер спецификации связанного плана
    is
      NRESULT                 PKG_STD.TREF; -- Рег. номер спецификации связанного плана
    begin
      /* Считываем запись */
      begin
        select S.RN
          into NRESULT
          from FCPRODPLAN   T,
               FCPRODPLANSP S
         where T.RN = (select P.RN
                         from DOCLINKS     L,
                              FCPRODPLAN   P,
                              FCPRODPLANSP SP
                        where SP.RN = NFCPRODPLANSP
                          and L.IN_DOCUMENT = SP.PRN
                          and L.IN_UNITCODE = 'CostProductPlans'
                          and L.OUT_UNITCODE = 'CostProductPlans'
                          and P.RN = L.OUT_DOCUMENT
                          and P.CATEGORY = 1
                          and ROWNUM = 1)
           and S.PRN = T.RN
           and S.PRODCMPSP = NPRODCMPSP;
      exception
        when others then
          NRESULT := null;
      end;
      /* Возвращаем результат */
      return NRESULT;
    end FCPRODPLANSP_LINKED_GET;
  begin
    /* Начинаем формирование XML */
    PKG_XFAST.PROLOGUE(ITYPE => PKG_XFAST.CONTENT_);
    /* Считываем свойства детали для её позиционирования в модели */
    FIND_DOCS_PROPS_CODE_EX(NFLAG_SMART => 1,
                            NCOMPVERS   => NCOMPANY,
                            SUNITCODE   => 'CostProductCompositionSpec',
                            SPROPCODE   => SDP_MODEL_ID,
                            NRN         => NDP_MODEL_ID);
    FIND_DOCS_PROPS_CODE_EX(NFLAG_SMART => 1,
                            NCOMPVERS   => NCOMPANY,
                            SUNITCODE   => 'CostProductCompositionSpec',
                            SPROPCODE   => SDP_MODEL_BG_COLOR,
                            NRN         => NDP_MODEL_BG_COLOR);
    /* Открываем корень */
    PKG_XFAST.DOWN_NODE(SNAME => 'XDATA');
    /* Векторная модель */
    PKG_XFAST.DOWN_NODE(SNAME => 'BMODEL');
    PKG_XFAST.VALUE(LBVALUE => FCMATRESOURCE_IMAGE_GET(NRN        => FCPRODPLANSP_MATRES_GET(NFCPRODPLANSP => NFCPRODPLANSP),
                                                       SFLINKTYPE => SFLINKTYPE_SVG_MODEL));
    PKG_XFAST.UP();
    /* Цикл по планам и отчетам производства изделий */
    for REC in (select S.RN NRN,
                       (select F.NAME from FCMATRESOURCE F where F.RN = S.MTR_RES) SNAME,
                       PV_MID.STR_VALUE SMODEL_ID,
                       (select PV_MFC.STR_VALUE
                          from DOCS_PROPS_VALS PV_MFC
                         where PV_MFC.UNIT_RN = S.RN
                           and PV_MFC.DOCS_PROP_RN = NDP_MODEL_BG_COLOR) SMODEL_BG_COLOR
                  from FCPRODPLANSP    T,
                       FCPRODCMPSP     S,
                       DOCS_PROPS_VALS PV_MID
                 where T.RN = NFCPRODPLANSP
                   and S.PRN = T.PRODCMP
                   and PV_MID.UNIT_RN = S.RN
                   and PV_MID.DOCS_PROP_RN = NDP_MODEL_ID)
    loop
      /* Получаем рег. номер связанной спецификации плана */
      NFCPRODPLANSP_LINKED := FCPRODPLANSP_LINKED_GET(NPRODCMPSP => REC.NRN, NFCPRODPLANSP => NFCPRODPLANSP);
      /* Открываем план */
      PKG_XFAST.DOWN_NODE(SNAME => 'XFCPRODCMP');
      /* Описываем план */
      PKG_XFAST.ATTR(SNAME => 'NRN', NVALUE => REC.NRN);
      PKG_XFAST.ATTR(SNAME => 'SNAME', SVALUE => REC.SNAME);
      PKG_XFAST.ATTR(SNAME => 'SMODEL_ID', SVALUE => REC.SMODEL_ID);
      PKG_XFAST.ATTR(SNAME => 'SMODEL_BG_COLOR', SVALUE => REC.SMODEL_BG_COLOR);
      PKG_XFAST.ATTR(SNAME => 'NFCPRODPLANSP_LINK', NVALUE => NFCPRODPLANSP_LINKED);
      /* Закрываем план */
      PKG_XFAST.UP();
    end loop;
    /* Закрываем корень */
    PKG_XFAST.UP();
    /* Сериализуем */
    COUT := PKG_XFAST.SERIALIZE_TO_CLOB();
    /* Завершаем формирование XML */
    PKG_XFAST.EPILOGUE();
  exception
    when others then
      /* Завершаем формирование XML */
      PKG_XFAST.EPILOGUE();
      /* Вернем ошибку */
      PKG_STATE.DIAGNOSTICS_STACKED();
      P_EXCEPTION(0, PKG_STATE.SQL_ERRM());
  end FCPRODCMP_DETAILS_GET;

end PKG_P8PANELS_MECHREC;
/

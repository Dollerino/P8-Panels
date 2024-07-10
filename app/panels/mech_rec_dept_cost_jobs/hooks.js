/*
    Парус 8 - Панели мониторинга - ПУП - Загрузка цеха
    Кастомные хуки
*/

//---------------------
//Подключение библиотек
//---------------------

import { useState, useCallback, useEffect, useContext } from "react"; //Классы React
import { BackEndСtx } from "../../context/backend"; //Контекст взаимодействия с сервером
import { object2Base64XML, formatDateRF } from "../../core/utils"; //Вспомогательные функции

//---------
//Константы
//---------

//Размер страницы данных
const DATA_GRID_PAGE_SIZE_SMALL = 5;
const DATA_GRID_PAGE_SIZE_LARGE = 12;

//-----------
//Тело модуля
//-----------

//Хук для основной таблицы панели
const useMechRecDeptCostJobs = (subdiv, fullDate, workHours) => {
    //Собственное состояние - таблица данных
    const [costJobs, setCostJobs] = useState({
        dataLoaded: false,
        columnsDef: [],
        orders: null,
        rows: [],
        reload: true,
        pageNumber: 1,
        morePages: true,
        fixedHeader: false,
        fixedColumns: 0,
        date: null
    });

    //Подключение к контексту взаимодействия с сервером
    const { executeStored, SERV_DATA_TYPE_CLOB } = useContext(BackEndСtx);

    //При необходимости обновить данные таблицы
    useEffect(() => {
        //Если указано подразделение и необходимо обновить, либо изменилась дата
        if (subdiv && (costJobs.reload || costJobs.date !== fullDate)) {
            const loadData = async () => {
                const data = await executeStored({
                    stored: "PKG_P8PANELS_MECHREC.FCJOBS_DEP_LOAD_DG_GET",
                    args: {
                        NSUBDIV: subdiv,
                        SMONTH_YEAR: fullDate,
                        NWORKHOURS: workHours,
                        CORDERS: { VALUE: object2Base64XML(costJobs.orders, { arrayNodeName: "orders" }), SDATA_TYPE: SERV_DATA_TYPE_CLOB },
                        NPAGE_NUMBER: costJobs.pageNumber,
                        NPAGE_SIZE: DATA_GRID_PAGE_SIZE_LARGE,
                        NINCLUDE_DEF: 1
                    },
                    respArg: "COUT"
                });
                setCostJobs(pv => ({
                    ...pv,
                    fixedHeader: data.XDATA_GRID.fixedHeader,
                    fixedColumns: data.XDATA_GRID.fixedColumns,
                    columnsDef: data.XCOLUMNS_DEF ? [...data.XCOLUMNS_DEF] : pv.columnsDef,
                    rows: pv.pageNumber == 1 ? [...(data.XROWS || [])] : [...pv.rows, ...(data.XROWS || [])],
                    dataLoaded: true,
                    reload: false,
                    morePages: (data.XROWS || []).length >= DATA_GRID_PAGE_SIZE_LARGE,
                    date: fullDate
                }));
            };
            loadData();
        }
    }, [costJobs.reload, subdiv, fullDate, costJobs.date, costJobs.orders, costJobs.pageNumber, executeStored, workHours, SERV_DATA_TYPE_CLOB]);

    return [costJobs, setCostJobs];
};

//Хук таблицы подразделений цехов
const useInsDepartment = fullDate => {
    //Собственное состояние
    let [insDepartments, setInsDepartments] = useState({
        dataLoaded: false,
        columnsDef: [],
        rows: [],
        reload: true,
        pageNumber: 1,
        morePages: true
    });

    //Подключение к контексту взаимодействия с сервером
    const { executeStored } = useContext(BackEndСtx);

    //При необходимости обновить данные таблицы
    useEffect(() => {
        const loadData = async () => {
            const data = await executeStored({
                stored: "PKG_P8PANELS_MECHREC.INS_DEPARTMENT_DG_GET",
                args: {
                    SMONTH_YEAR: fullDate,
                    NPAGE_SIZE: DATA_GRID_PAGE_SIZE_SMALL,
                    NINCLUDE_DEF: insDepartments.dataLoaded ? 0 : 1
                },
                respArg: "COUT",
                attributeValueProcessor: (name, val) => (["DBGNDATE", "DENDDATE"].includes(name) ? formatDateRF(val) : val)
            });
            setInsDepartments(pv => ({
                ...pv,
                columnsDef: data.XCOLUMNS_DEF ? [...data.XCOLUMNS_DEF] : pv.columnsDef,
                rows: pv.pageNumber == 1 ? [...(data.XROWS || [])] : [...pv.rows, ...(data.XROWS || [])],
                dataLoaded: true,
                reload: false,
                morePages: (data.XROWS || []).length >= DATA_GRID_PAGE_SIZE_SMALL
            }));
        };
        if (insDepartments.reload) {
            loadData();
        }
    }, [executeStored, fullDate, insDepartments.dataLoaded, insDepartments.reload]);

    return [insDepartments, setInsDepartments];
};

//Хук для диалога фильтра
const useFilter = (currentMonth, currentYear) => {
    //Собственное состояние - фильтр
    const [filter, setFilter] = useState({
        init: true,
        openedDepartment: false,
        date: {
            month: currentMonth,
            year: currentYear,
            fullDate: currentMonth.toString().padStart(2, "0") + "." + currentYear
        },
        department: { NRN: null, SCODE: "", SNAME: "" },
        workDays: 0,
        workHours: 0,
        totalWorkHours: 0
    });

    //Подключение к контексту взаимодействия с сервером
    const { executeStored } = useContext(BackEndСtx);

    //Считываем количества рабочих дней
    const getWorkDays = useCallback(
        async ({ newDate, init }) => {
            const data = await executeStored({
                stored: "PKG_P8PANELS_MECHREC.ENPERIOD_WORKDAYS_GET",
                args: { SMONTH_YEAR: newDate.fullDate }
            });
            if (init) {
                setFilter(pv => ({ ...pv, workDays: data.NWORKDAYS, init: false }));
            } else {
                setFilter(pv => ({
                    ...pv,
                    date: { ...newDate },
                    department: filter.department,
                    workDays: data.NWORKDAYS,
                    totalWorkHours: data.NWORKDAYS * filter.workHours
                }));
            }
        },
        [executeStored, filter]
    );

    //Считываем количество рабочих часов
    const getWorkHours = useCallback(
        async department => {
            const data = await executeStored({
                stored: "PKG_P8PANELS_MECHREC.INS_DEPARTMENT_WORKHOURS_GET",
                args: { NSUBDIV: department.NRN }
            });
            setFilter(pv => ({
                ...pv,
                openedDepartment: false,
                department: { ...department },
                workHours: data.NWORKHOURS,
                totalWorkHours: filter.workDays * data.NWORKHOURS
            }));
        },
        [executeStored, filter.workDays]
    );

    //При необходимости обновить данные таблицы
    useEffect(() => {
        if (filter.init) {
            getWorkDays({ newDate: { month: filter.date.month, year: filter.date.year, fullDate: filter.date.fullDate }, init: filter.init });
        }
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, [filter.init]);

    return [filter, setFilter, getWorkDays, getWorkHours];
};

export { useMechRecDeptCostJobs, useInsDepartment, useFilter };

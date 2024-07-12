/*
    Парус 8 - Панели мониторинга - ПУП - Производственный план цеха
    Кастомные хуки
*/

//---------------------
//Подключение библиотек
//---------------------

import React, { useState, useEffect, useContext } from "react"; //Классы React
import { BackEndСtx } from "../../context/backend"; //Контекст взаимодействия с сервером
import { object2Base64XML, formatDateRF } from "../../core/utils"; //Вспомогательные функции

//---------
//Константы
//---------

//Размер страницы данных
const DATA_GRID_PAGE_SIZE_SMALL = 5;
const DATA_GRID_PAGE_SIZE_LARGE = 10;

//-----------
//Тело модуля
//-----------

//Клиентский отбор каталогов по поисковой фразе и наличию планов
export const useFilteredPlans = (plans, filter) => {
    const filteredPlans = React.useMemo(() => {
        return plans.filter(catalog => catalog.SDOC_INFO.toString().toLowerCase().includes(filter.planName));
    }, [plans, filter]);

    return filteredPlans;
};

//Хук для основной таблицы
const useDeptCostProdPlans = () => {
    //Собственное состояние - таблица данных
    const [state, setState] = useState({
        init: false,
        showPlanList: false,
        showIncomeFromDeps: null,
        showFcroutelst: null,
        planList: [],
        planListLoaded: false,
        selectedPlan: {},
        dataLoaded: false,
        columnsDef: [],
        orders: null,
        rows: [],
        reload: true,
        pageNumber: 1,
        morePages: true,
        fixedHeader: false,
        fixedColumns: 0
    });

    //Подключение к контексту взаимодействия с сервером
    const { executeStored, SERV_DATA_TYPE_CLOB } = useContext(BackEndСtx);

    //При необходимости обновить данные таблицы
    useEffect(() => {
        if (state.selectedPlan.NRN) {
            const loadData = async () => {
                const data = await executeStored({
                    stored: "PKG_P8PANELS_MECHREC.FCPRODPLANSP_DEPT_DG_GET",
                    args: {
                        NFCPRODPLAN: state.selectedPlan.NRN,
                        CORDERS: { VALUE: object2Base64XML(state.orders, { arrayNodeName: "orders" }), SDATA_TYPE: SERV_DATA_TYPE_CLOB },
                        NPAGE_NUMBER: state.pageNumber,
                        NPAGE_SIZE: DATA_GRID_PAGE_SIZE_LARGE,
                        NINCLUDE_DEF: state.dataLoaded ? 0 : 1
                    },
                    respArg: "COUT",
                    attributeValueProcessor: (name, val) => (name === "caption" ? undefined : val)
                });
                setState(pv => ({
                    ...pv,
                    fixedHeader: data.XDATA_GRID.fixedHeader,
                    fixedColumns: data.XDATA_GRID.fixedColumns,
                    columnsDef: data.XCOLUMNS_DEF ? [...data.XCOLUMNS_DEF] : pv.columnsDef,
                    rows: pv.pageNumber == 1 ? [...(data.XROWS || [])] : [...pv.rows, ...(data.XROWS || [])],
                    dataLoaded: true,
                    reload: false,
                    morePages: (data.XROWS || []).length >= DATA_GRID_PAGE_SIZE_LARGE
                }));
            };
            if (state.reload) {
                loadData();
            }
        }
    }, [state.selectedPlan, state.reload, state.orders, state.pageNumber, state.dataLoaded, executeStored, SERV_DATA_TYPE_CLOB]);

    //При подключении компонента к странице
    useEffect(() => {
        const initPlans = async () => {
            const data = await executeStored({
                stored: "PKG_P8PANELS_MECHREC.FCPRODPLAN_DEPT_INIT",
                args: {},
                respArg: "COUT",
                isArray: name => name === "XFCPRODPLANS",
                attributeValueProcessor: (name, val) => (name === "SPERIOD" ? undefined : val)
            });
            setState(pv => ({ ...pv, init: true, planList: [...(data?.XFCPRODPLANS || [])], planListLoaded: true }));
        };
        if (!state.init) {
            initPlans();
        }
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []);

    return [state, setState];
};

//Хук для таблицы маршрутных листов
const useCostRouteLists = task => {
    //Собственное состояние - таблица данных
    const [costRouteLists, setCostRouteLists] = useState({
        dataLoaded: false,
        columnsDef: [],
        orders: null,
        rows: [],
        reload: true,
        pageNumber: 1,
        morePages: true,
        editPriorNRN: null
    });

    //Подключение к контексту взаимодействия с сервером
    const { executeStored, SERV_DATA_TYPE_CLOB } = useContext(BackEndСtx);

    //При необходимости обновить данные таблицы
    useEffect(() => {
        const loadData = async () => {
            const data = await executeStored({
                stored: "PKG_P8PANELS_MECHREC.FCROUTLST_DEPT_DG_GET",
                args: {
                    NFCPRODPLANSP: task,
                    CORDERS: { VALUE: object2Base64XML(costRouteLists.orders, { arrayNodeName: "orders" }), SDATA_TYPE: SERV_DATA_TYPE_CLOB },
                    NPAGE_NUMBER: costRouteLists.pageNumber,
                    NPAGE_SIZE: DATA_GRID_PAGE_SIZE_SMALL,
                    NINCLUDE_DEF: costRouteLists.dataLoaded ? 0 : 1
                },
                respArg: "COUT"
            });
            setCostRouteLists(pv => ({
                ...pv,
                columnsDef: data.XCOLUMNS_DEF ? [...data.XCOLUMNS_DEF] : pv.columnsDef,
                rows: pv.pageNumber == 1 ? [...(data.XROWS || [])] : [...pv.rows, ...(data.XROWS || [])],
                dataLoaded: true,
                reload: false,
                morePages: (data.XROWS || []).length >= DATA_GRID_PAGE_SIZE_SMALL
            }));
        };
        if (costRouteLists.reload && task) {
            loadData();
        }
    }, [
        SERV_DATA_TYPE_CLOB,
        costRouteLists.dataLoaded,
        costRouteLists.orders,
        costRouteLists.pageNumber,
        costRouteLists.reload,
        executeStored,
        task
    ]);

    return [costRouteLists, setCostRouteLists];
};

//Хук для таблицы строк маршрутного листа
const useCostRouteListsSpecs = mainRowRN => {
    //Собственное состояние - таблица данных
    const [costRouteListsSpecs, setCostRouteListsSpecs] = useState({
        dataLoaded: false,
        columnsDef: [],
        orders: null,
        rows: [],
        reload: true,
        pageNumber: 1,
        morePages: true
    });

    //Подключение к контексту взаимодействия с сервером
    const { executeStored, SERV_DATA_TYPE_CLOB } = useContext(BackEndСtx);

    //При необходимости обновить данные таблицы
    useEffect(() => {
        const loadData = async () => {
            const data = await executeStored({
                stored: "PKG_P8PANELS_MECHREC.FCROUTLSTSP_DEPT_DG_GET",
                args: {
                    NFCROUTLST: mainRowRN,
                    CORDERS: {
                        VALUE: object2Base64XML(costRouteListsSpecs.orders, { arrayNodeName: "orders" }),
                        SDATA_TYPE: SERV_DATA_TYPE_CLOB
                    },
                    NPAGE_NUMBER: costRouteListsSpecs.pageNumber,
                    NPAGE_SIZE: DATA_GRID_PAGE_SIZE_LARGE,
                    NINCLUDE_DEF: costRouteListsSpecs.dataLoaded ? 0 : 1
                },
                respArg: "COUT"
            });
            setCostRouteListsSpecs(pv => ({
                ...pv,
                columnsDef: data.XCOLUMNS_DEF ? [...data.XCOLUMNS_DEF] : pv.columnsDef,
                rows: pv.pageNumber == 1 ? [...(data.XROWS || [])] : [...pv.rows, ...(data.XROWS || [])],
                dataLoaded: true,
                reload: false,
                morePages: (data.XROWS || []).length >= DATA_GRID_PAGE_SIZE_LARGE
            }));
        };
        if (costRouteListsSpecs.reload) {
            loadData();
        }
    }, [
        SERV_DATA_TYPE_CLOB,
        costRouteListsSpecs.dataLoaded,
        costRouteListsSpecs.orders,
        costRouteListsSpecs.pageNumber,
        costRouteListsSpecs.reload,
        executeStored,
        mainRowRN
    ]);

    return [costRouteListsSpecs, setCostRouteListsSpecs];
};

//Хук для таблицы сдачи продукции
const useIncomFromDeps = task => {
    //Собственное состояние - таблица данных
    const [incomFromDeps, setIncomFromDeps] = useState({
        dataLoaded: false,
        columnsDef: [],
        orders: null,
        rows: [],
        reload: true,
        pageNumber: 1,
        morePages: true
    });

    //Подключение к контексту взаимодействия с сервером
    const { executeStored, SERV_DATA_TYPE_CLOB } = useContext(BackEndСtx);

    //При необходимости обновить данные таблицы
    useEffect(() => {
        const loadData = async () => {
            const data = await executeStored({
                stored: "PKG_P8PANELS_MECHREC.INCOMEFROMDEPS_DEPT_DG_GET",
                args: {
                    NFCPRODPLANSP: task,
                    CORDERS: { VALUE: object2Base64XML(incomFromDeps.orders, { arrayNodeName: "orders" }), SDATA_TYPE: SERV_DATA_TYPE_CLOB },
                    NPAGE_NUMBER: incomFromDeps.pageNumber,
                    NPAGE_SIZE: DATA_GRID_PAGE_SIZE_LARGE,
                    NINCLUDE_DEF: incomFromDeps.dataLoaded ? 0 : 1
                },
                attributeValueProcessor: (name, val) => (["DDUE_DATE"].includes(name) ? formatDateRF(val) : val),
                respArg: "COUT"
            });
            setIncomFromDeps(pv => ({
                ...pv,
                columnsDef: data.XCOLUMNS_DEF ? [...data.XCOLUMNS_DEF] : pv.columnsDef,
                rows: pv.pageNumber == 1 ? [...(data.XROWS || [])] : [...pv.rows, ...(data.XROWS || [])],
                dataLoaded: true,
                reload: false,
                morePages: (data.XROWS || []).length >= DATA_GRID_PAGE_SIZE_LARGE
            }));
        };
        if (incomFromDeps.reload) {
            loadData();
        }
    }, [SERV_DATA_TYPE_CLOB, executeStored, incomFromDeps.dataLoaded, incomFromDeps.orders, incomFromDeps.pageNumber, incomFromDeps.reload, task]);

    return [incomFromDeps, setIncomFromDeps];
};

export { useDeptCostProdPlans, useCostRouteLists, useCostRouteListsSpecs, useIncomFromDeps };

//---------------------
//Подключение библиотек
//---------------------

import React, { useState, useCallback, useEffect, useContext } from "react"; //Классы React
import { BackEndСtx } from "../../context/backend"; //Контекст взаимодействия с сервером
import { object2Base64XML } from "../../core/utils"; //Вспомогательные функции

//---------
//Константы
//---------

//Размер страницы данных
const DATA_GRID_PAGE_SIZE = 50;

//---------------------------------------------
//Вспомогательные функции форматирования данных
//---------------------------------------------

//-----------
//Тело модуля
//-----------

//Клиентский отбор сменных заданий по поисковой фразе
export const useFilteredFcjobs = (jobs, filter) => {
    const filteredJobs = React.useMemo(() => {
        return jobs.filter(catalog => catalog.SDOC_INFO.toString().toLowerCase().includes(filter.jobName));
    }, [jobs, filter]);

    return filteredJobs;
};

//Хук для основной таблицы
const useCostJobs = () => {
    //Собственное состояние - таблица данных
    const [state, setState] = useState({
        init: false,
        showJobList: false,
        jobList: [],
        jobListLoaded: false,
        selectedJob: {},
        dataLoaded: false
    });

    //Подключение к контексту взаимодействия с сервером
    const { executeStored } = useContext(BackEndСtx);

    //При подключении компонента к странице
    useEffect(() => {
        const initPlans = async () => {
            const data = await executeStored({
                stored: "PKG_P8PANELS_MECHREC.FCJOBS_INIT",
                args: {},
                respArg: "COUT",
                isArray: name => name === "XFCJOBS",
                attributeValueProcessor: (name, val) => (["NHAVE_NOTE"].includes(name) ? val == 1 : val)
            });
            setState(pv => ({
                ...pv,
                init: true,
                jobList: [...(data.XFCJOBS || [])],
                jobListLoaded: true
            }));
        };
        if (!state.init) {
            initPlans();
        }
        // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []);

    return [state, setState];
};

//Хук для таблицы операций
const useCostJobsSpecs = task => {
    //Собственное состояние - таблица данных
    const [costJobsSpecs, setCostJobsSpecs] = useState({
        task: null,
        dataLoaded: false,
        columnsDef: [],
        orders: null,
        rows: [],
        selectedRow: {},
        reload: true,
        pageNumber: 1,
        morePages: true
    });

    //Подключение к контексту взаимодействия с сервером
    const { executeStored, SERV_DATA_TYPE_CLOB } = useContext(BackEndСtx);

    //Выдача задания
    const issueCostJobsSpecs = useCallback(
        async prms => {
            try {
                await executeStored({
                    stored: "PKG_P8PANELS_MECHREC.FCJOBSSP_ISSUE",
                    args: { NFCJOBS: prms.NFCJOBS, SFCJOBSSP_LIST: prms.SFCJOBSSP_LIST }
                });
            } catch (e) {
                throw new Error(e.message);
            }
        },
        [executeStored]
    );

    //При необходимости обновить данные таблицы
    useEffect(() => {
        //Если изменилось сменное задание - обновляем состояние
        if (costJobsSpecs.dataLoaded && costJobsSpecs.task !== task) {
            setCostJobsSpecs(pv => ({
                ...pv,
                dataLoaded: false,
                columnsDef: [],
                orders: null,
                rows: [],
                selectedRow: {},
                reload: true,
                pageNumber: 1,
                morePages: true
            }));
        }
        //Если необходимо перезагрузить
        if (costJobsSpecs.reload) {
            const loadData = async () => {
                const data = await executeStored({
                    stored: "PKG_P8PANELS_MECHREC.FCJOBSSP_DG_GET",
                    args: {
                        NFCJOBS: task,
                        NPAGE_NUMBER: costJobsSpecs.pageNumber,
                        NPAGE_SIZE: DATA_GRID_PAGE_SIZE,
                        CORDERS: { VALUE: object2Base64XML(costJobsSpecs.orders, { arrayNodeName: "orders" }), SDATA_TYPE: SERV_DATA_TYPE_CLOB },
                        NINCLUDE_DEF: costJobsSpecs.dataLoaded ? 0 : 1
                    },
                    respArg: "COUT",
                    attributeValueProcessor: (name, val) => (["NSELECT"].includes(name) ? val === 1 : val)
                });
                setCostJobsSpecs(pv => ({
                    ...pv,
                    task: task,
                    columnsDef: data.XCOLUMNS_DEF ? [...data.XCOLUMNS_DEF] : pv.columnsDef,
                    rows: pv.pageNumber == 1 ? [...(data.XROWS || [])] : [...pv.rows, ...(data.XROWS || [])],
                    dataLoaded: true,
                    reload: false,
                    morePages: (data.XROWS || []).length >= DATA_GRID_PAGE_SIZE
                }));
            };
            loadData();
        }
    }, [
        SERV_DATA_TYPE_CLOB,
        costJobsSpecs.dataLoaded,
        costJobsSpecs.orders,
        costJobsSpecs.pageNumber,
        costJobsSpecs.reload,
        costJobsSpecs.selectedRow,
        costJobsSpecs.task,
        executeStored,
        task
    ]);

    return [costJobsSpecs, setCostJobsSpecs, issueCostJobsSpecs];
};

//Хук для таблицы рабочих центров
const useEquipConfiguration = task => {
    //Собственное состояние - таблица данных
    const [equipConfiguration, setEquipConfiguration] = useState({
        task: null,
        dataLoaded: false,
        columnsDef: [],
        orders: null,
        rows: [],
        selectedRow: {},
        reload: true,
        pageNumber: 1,
        morePages: true
    });

    //Подключение к контексту взаимодействия с сервером
    const { executeStored, SERV_DATA_TYPE_CLOB } = useContext(BackEndСtx);

    //Включение станка в строку сменного задания
    const includeEquipConfiguration = useCallback(
        async prms => {
            try {
                await executeStored({
                    stored: "PKG_P8PANELS_MECHREC.FCJOBSSP_INC_EQCONFIG",
                    args: { NEQCONFIG: prms.NEQCONFIG, NFCJOBSSP: prms.NFCJOBSSP, NQUANT_PLAN: prms.NQUANT_PLAN }
                });
            } catch (e) {
                throw new Error(e.message);
            }
        },
        [executeStored]
    );

    //Исключение станка из строки сменного задания
    const excludeEquipConfiguration = useCallback(
        async prms => {
            try {
                await executeStored({
                    stored: "PKG_P8PANELS_MECHREC.FCJOBSSP_EXC_EQCONFIG",
                    args: { NFCJOBSSP: prms.NFCJOBSSP }
                });
            } catch (e) {
                throw new Error(e.message);
            }
        },
        [executeStored]
    );

    //При необходимости обновить данные таблицы
    useEffect(() => {
        //Если изменилось сменное задание - обновляем состояние
        if (equipConfiguration.dataLoaded && equipConfiguration.task !== task) {
            setEquipConfiguration(pv => ({
                ...pv,
                dataLoaded: false,
                columnsDef: [],
                orders: null,
                rows: [],
                selectedRow: {},
                reload: true,
                pageNumber: 1,
                morePages: true
            }));
        }
        if (equipConfiguration.reload) {
            const loadData = async () => {
                const data = await executeStored({
                    stored: "PKG_P8PANELS_MECHREC.EQCONFIG_DG_GET",
                    args: {
                        NFCJOBS: task,
                        CORDERS: { VALUE: object2Base64XML(equipConfiguration.orders, { arrayNodeName: "orders" }), SDATA_TYPE: SERV_DATA_TYPE_CLOB },
                        NPAGE_NUMBER: equipConfiguration.pageNumber,
                        NPAGE_SIZE: DATA_GRID_PAGE_SIZE,
                        NINCLUDE_DEF: equipConfiguration.dataLoaded ? 0 : 1
                    },
                    respArg: "COUT",
                    attributeValueProcessor: (name, val) => (["NSELECT"].includes(name) ? val === 1 : val)
                });
                setEquipConfiguration(pv => ({
                    ...pv,
                    task: task,
                    columnsDef: data.XCOLUMNS_DEF ? [...data.XCOLUMNS_DEF] : pv.columnsDef,
                    rows: pv.pageNumber == 1 ? [...(data.XROWS || [])] : [...pv.rows, ...(data.XROWS || [])],
                    dataLoaded: true,
                    reload: false,
                    morePages: (data.XROWS || []).length >= DATA_GRID_PAGE_SIZE
                }));
            };
            loadData();
        }
    }, [
        SERV_DATA_TYPE_CLOB,
        equipConfiguration.dataLoaded,
        equipConfiguration.orders,
        equipConfiguration.pageNumber,
        equipConfiguration.reload,
        equipConfiguration.selectedRow,
        equipConfiguration.task,
        task,
        executeStored
    ]);

    return [equipConfiguration, setEquipConfiguration, includeEquipConfiguration, excludeEquipConfiguration];
};

export { useCostJobs, useCostJobsSpecs, useEquipConfiguration };

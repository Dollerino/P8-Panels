/*
    Парус 8 - Панели мониторинга - ПУП - Выдача сменного задания
    Панель мониторинга: Корневая панель выдачи сменного задания
*/

//---------------------
//Подключение библиотек
//---------------------

import React, { useContext, useState } from "react"; //Классы React
import PropTypes from "prop-types"; //Контроль свойств компонента
import { Drawer, Fab, Box, List, ListItemButton, ListItemText, Typography, TextField } from "@mui/material"; //Интерфейсные элементы
import { MessagingСtx } from "../../context/messaging"; //Контекст сообщений
import { CostJobsSpecsDataGrid } from "./fcjobssp"; //Собственные хуки таблиц
import { useCostJobs, useFilteredFcjobs } from "./hooks"; //Вспомогательные хуки

//---------
//Константы
//---------

//Стили
const STYLES = {
    JOBS_FINDER: { marginTop: "10px", marginLeft: "10px", width: "93%" },
    JOBS_LIST_ITEM_PRIMARY: { wordWrap: "break-word" },
    JOBS_BUTTON: { position: "absolute" },
    JOBS_DRAWER: {
        width: "350px",
        display: "inline-block",
        flexShrink: 0,
        [`& .MuiDrawer-paper`]: { width: "350px", display: "inline-block", boxSizing: "border-box" }
    },
    CONTAINER: { textAlign: "center" }
};

//------------------------------------
//Вспомогательные функции и компоненты
//------------------------------------

//Список сменных заданий
const JobList = ({ jobs = [], selectedJob, filter, setFilter, onClick } = {}) => {
    //Генерация содержимого
    return (
        <div>
            <TextField
                sx={STYLES.JOBS_FINDER}
                name="jobFilter"
                label="Сменное задание"
                value={filter.jobName}
                variant="standard"
                fullWidth
                onChange={event => {
                    setFilter(pv => ({ ...pv, jobName: event.target.value }));
                }}
            ></TextField>
            <List>
                {jobs.map(p => (
                    <ListItemButton key={p.NRN} selected={p.NRN === selectedJob.NRN} onClick={() => (onClick ? onClick(p) : null)}>
                        <ListItemText primary={<Typography sx={STYLES.JOBS_LIST_ITEM_PRIMARY}>{p.SDOC_INFO}</Typography>} />
                    </ListItemButton>
                ))}
            </List>
        </div>
    );
};

//Контроль свойств - Список каталогов планов
JobList.propTypes = {
    jobs: PropTypes.array,
    selectedJob: PropTypes.object,
    onClick: PropTypes.func,
    filter: PropTypes.object,
    setFilter: PropTypes.func
};

//-----------
//Тело модуля
//-----------

//Корневая панель выдачи сменного задания
const MechRecCostJobs = () => {
    //Собственное состояние - таблица данных
    const [state, setState] = useCostJobs();

    //Состояние для фильтра каталогов
    const [filter, setFilter] = useState({ jobName: "" });

    //Массив отфильтрованных каталогов
    const filteredJobs = useFilteredFcjobs(state.jobList, filter);

    //Подключение к контексту сообщений
    const { InlineMsgInfo } = useContext(MessagingСtx);

    //Выбор плана
    const selectJob = job => {
        //Обновляем состояние
        setState(pv => ({
            ...pv,
            selectedJob: job,
            showJobList: false,
            dataLoaded: false
        }));
    };

    //Сброс выбора плана
    const unselectJob = () => {
        //Обновляем состояние
        setState(pv => ({
            ...pv,
            selectedJob: {},
            showJobList: false,
            dataLoaded: false
        }));
    };

    //Обработка нажатия на элемент в списке планов
    const handleJobClick = job => {
        if (state.selectedJob.NRN != job.NRN) selectJob(job);
        else unselectJob();
    };

    //Генерация содержимого
    return (
        <Box p={2}>
            <Fab variant="extended" sx={STYLES.JOBS_BUTTON} onClick={() => setState(pv => ({ ...pv, showJobList: !pv.showJobList }))}>
                Сменные задания
            </Fab>
            <Drawer anchor={"left"} open={state.showJobList} onClose={() => setState(pv => ({ ...pv, showJobList: false }))} sx={STYLES.JOBS_DRAWER}>
                <JobList jobs={filteredJobs} selectedJob={state.selectedJob} filter={filter} setFilter={setFilter} onClick={handleJobClick} />
            </Drawer>
            <div style={STYLES.CONTAINER}>
                {state.selectedJob.NRN ? (
                    <>
                        <Typography variant={"h6"}>{`Сменное задание №${state.selectedJob.SDOC_NUMB} на ${state.selectedJob.SPERIOD}`}</Typography>
                        <Typography variant={"h6"}>{`${state.selectedJob.SSUBDIV}`}</Typography>
                        <CostJobsSpecsDataGrid task={state.selectedJob.NRN} haveNote={state.selectedJob.NHAVE_NOTE} />
                    </>
                ) : !state.selectedJob.NRN ? (
                    <InlineMsgInfo okBtn={false} text={"Укажите сменное задание для отображения информации"} />
                ) : null}
            </div>
        </Box>
    );
};

//----------------
//Интерфейс модуля
//----------------

export { MechRecCostJobs };

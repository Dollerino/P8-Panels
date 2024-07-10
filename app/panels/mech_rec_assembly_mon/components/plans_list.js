/*
    Парус 8 - Панели мониторинга - ПУП - Мониторинг сборки изделий
    Компонент: Список выпусков планов
*/

//---------------------
//Подключение библиотек
//---------------------

import React, { useState } from "react"; //Классы React
import { Container, Grid, IconButton, Icon } from "@mui/material"; //Интерфейсные элементы
import PropTypes from "prop-types"; //Контроль свойств компонента
import { PlanSpecsListItem } from "./plans_list_item"; //Элемент списка выпусков планов

//---------
//Константы
//---------

//Количество одновременно отображаемых элементов списка по умолчанию
const DEFAULT_PAGE_SIZE = 5;

//Стили
const STYLES = {
    PLAN_DOCUMENTS_LIST: { minWidth: "1024px" },
    NAVIGATE_BUTTONS: { color: "text.title.fontColor" }
};

//-----------
//Тело модуля
//-----------

//Список выпусков планов
const PlanSpecsList = ({ planSpecs, pageSize = DEFAULT_PAGE_SIZE, onItemClick }) => {
    //Состояние прокрутки списка отображаемых планов
    const [scroll, setScroll] = useState(0);

    //Отработка нажатия на прокрутку списка выпусков планов влево
    const handleScrollLeft = () => setScroll(pv => (pv <= 1 ? 0 : pv - 1));

    //Отработка нажатия на прокрутку списка выпусков планов вправо
    const handleScrollRight = () => setScroll(pv => (pv + pageSize >= planSpecs.length ? pv : pv + 1));

    //Сборка представления
    return (
        <Container>
            <Grid container direction="row" justifyContent="center" alignItems="center" spacing={2} sx={STYLES.PLAN_DOCUMENTS_LIST}>
                <Grid item display="flex" justifyContent="center" xs={1}>
                    <IconButton onClick={handleScrollLeft} disabled={scroll <= 0}>
                        <Icon sx={STYLES.NAVIGATE_BUTTONS}>navigate_before</Icon>
                    </IconButton>
                </Grid>
                {planSpecs.map((el, i) =>
                    i >= scroll && i < scroll + pageSize ? (
                        <Grid item key={`${el.NRN}_${i}`} xs={2}>
                            <PlanSpecsListItem
                                card={el}
                                cardIndex={i}
                                onClick={(card, cardIndex) => (onItemClick ? onItemClick(card, cardIndex) : null)}
                            />
                        </Grid>
                    ) : null
                )}
                <Grid item display="flex" justifyContent="center" xs={1}>
                    <IconButton onClick={handleScrollRight} disabled={scroll + pageSize >= planSpecs.length}>
                        <Icon sx={STYLES.NAVIGATE_BUTTONS}>navigate_next</Icon>
                    </IconButton>
                </Grid>
            </Grid>
        </Container>
    );
};

//Контроль свойств - Список выпусков планов
PlanSpecsList.propTypes = {
    planSpecs: PropTypes.arrayOf(PropTypes.object),
    pageSize: PropTypes.number,
    onItemClick: PropTypes.func
};

//----------------
//Интерфейс модуля
//----------------

export { PlanSpecsList };

import sap.title.TitleState;

function statePostCreate()
{
       if (TitleState.CHARACTER_RING != null) TitleState.CHARACTER_RING.visible = false;
}
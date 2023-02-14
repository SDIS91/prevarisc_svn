<?php

class MaintenanceController extends Zend_Controller_Action
{
    public function indexAction()
    {
		$this->_helper->layout()->disableLayout(); 
    }
}

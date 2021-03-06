'use strict';	// Strict Mode is a new feature in ECMAScript 5 that allows you to place a 
				// program, or a function, in a "strict" operating context. This strict 
				// context prevents certain actions from being taken and throws more exceptions.


// Declare common level module which depends on filters, services, directives and controllers.
angular.module('common', [
  'common-directives',
  'common-services'
]);
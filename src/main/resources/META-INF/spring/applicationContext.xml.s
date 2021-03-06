<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
	xsi:schemaLocation="http://www.springframework.org/schema/beans
        http://www.springframework.org/schema/beans/spring-beans-3.0.xsd
        http://www.springframework.org/schema/context
        http://www.springframework.org/schema/context/spring-context-3.0.xsd">
        
    <context:annotation-config/>
    
    <context:component-scan base-package="travel">
    	<context:exclude-filter type="annotation" expression="org.springframework.context.annotation.Configuration"/>
    </context:component-scan>
    
    <bean id="mongoTemplate" class="org.springframework.data.document.mongodb.MongoTemplate">
    	<constructor-arg name="mongo" ref="mongo"/>
    	<constructor-arg name="databaseName" value="mytravel"/>
    	<constructor-arg name="defaultCollectionName" value="travel"/>
    </bean>

	<!-- Factory bean that creates the Mongo instance -->
    <bean id="mongo" class="org.springframework.data.document.mongodb.MongoFactoryBean">
    	<property name="host" value="localhost"/>
    </bean>
    
	<!-- Use this post processor to translate any MongoExceptions thrown in @Repository annotated classes -->
	<bean class="org.springframework.dao.annotation.PersistenceExceptionTranslationPostProcessor"/>
    
</beans>
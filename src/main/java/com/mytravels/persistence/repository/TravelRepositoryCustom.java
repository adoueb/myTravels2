package com.mytravels.persistence.repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.core.mapreduce.MapReduceResults;
import org.springframework.stereotype.Repository;

import com.mytravels.persistence.domain.Stop;
import com.mytravels.persistence.domain.Travel;


// This class will perform CRUD operations on Travel and Image objects.

@Repository
public class TravelRepositoryCustom {

	@Autowired
	MongoOperations mongoOperations;

	public List<Travel> getTravels() {

		if (!mongoOperations.collectionExists(Travel.class)) {
			mongoOperations.createCollection(Travel.class);
		}

		List<Travel> travels = mongoOperations.findAll(Travel.class);
		System.out.println("Travels: " + travels);
		
		return travels;
	}

	public void addTravel(Travel travel) {
		mongoOperations.insert(travel);
	}
	
	public Travel findById(String travelId) {
		return mongoOperations.findById(travelId, Travel.class);
	}

	public void updateTravel(Travel travel) {
		mongoOperations.save(travel);
	}

	public void deleteTravelById(String travelId) {
		Travel travelToRemove = findById(travelId);
		mongoOperations.remove(travelToRemove);
	}

	public void deleteTravel(Travel travel) {
		mongoOperations.remove(travel);
	}

	public void updateStop(Stop stop) {
		mongoOperations.save(stop);
	}
}
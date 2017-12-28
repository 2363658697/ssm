package cn.et.food.service;

import java.util.List;

import cn.et.food.entity.Food;

public interface FoodService {

	public abstract List<Food> queryFoodByFoodName(String foodName);
	
	
	public abstract void saveFood(String foodName,String price);

	public abstract void updateFood(String foodId, String foodName,
			String price);
	
	public abstract void deleteFood(String foodId);
}
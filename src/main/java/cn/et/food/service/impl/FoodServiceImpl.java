package cn.et.food.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import cn.et.food.dao.FoodMapper;
import cn.et.food.entity.Food;
import cn.et.food.entity.FoodExample;
import cn.et.food.entity.FoodExample.Criteria;
import cn.et.food.service.FoodService;



@Service
public class FoodServiceImpl implements FoodService{
	@Autowired
	FoodMapper foodMapper;

	/* (non-Javadoc)
	 * @see cn.et.food.service.impl.FoodService#queryFoodByFoodName(java.lang.String)
	 */
	public List<Food> queryFoodByFoodName(String foodName) {

		FoodExample foodExample = new FoodExample();

		Criteria criteria = foodExample.createCriteria();
		
		criteria.andFoodnameLike("%"+foodName+"%");
		
		//自己写条件  FoodExample中方法addCriterion的权限改为public
		
		return foodMapper.selectByExample(foodExample);
	}


	public void saveFood(String foodName, String price) {
		Food food=new Food();
		food.setFoodname(foodName);
		food.setPrice(Double.valueOf(price));
		
		//foodMapper.insert(food); 该方法是插入表中所有的列
		
		foodMapper.insertSelective(food); //插入有数据的列
	}


	public void updateFood(String foodId, String foodName, String price) {
		Food food=new Food();   
		
		food.setFoodname(foodName);
		food.setPrice(Double.valueOf(price));
		food.setFoodid(Integer.valueOf(foodId));
		
		//foodMapper.updateByExample(food, foodExample);  sql语句：修改所有的列
		
		foodMapper.updateByPrimaryKeySelective(food); //sql语句：修改插入数据的列	
	}


	public void deleteFood(String foodId) {
		foodMapper.deleteByPrimaryKey(Integer.valueOf(foodId));
	}

	
	
}

import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { Location } from '@angular/common';

interface NutritionPlan {
  mealType: string;
  time: string;
  calories: number;
  protein: number;
  carbs: number;
  fats: number;
  image: string;
  foods: Array<{
    name: string;
    portion: string;
    calories: number;
    icon: string;
  }>;
}

@Component({
  selector: 'app-nutrition',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './nutrition.component.html',
  styleUrls: ['./nutrition.component.css']
})
export class NutritionComponent {
  constructor(private location: Location) {}

  dailyNutrition: NutritionPlan[] = [
    {
      mealType: 'Breakfast',
      time: '7:00 AM',
      calories: 450,
      protein: 25,
      carbs: 45,
      fats: 20,
      image: 'https://images.immediate.co.uk/production/volatile/sites/30/2017/08/smoothie-bowl-3a8632c.jpg?quality=90&resize=556,505',
      foods: [
        { name: 'Oatmeal', portion: '1 cup', calories: 150, icon: 'fa-bowl-food' },
        { name: 'Banana', portion: '1 medium', calories: 105, icon: 'fa-apple-whole' },
        { name: 'Greek Yogurt', portion: '1 cup', calories: 130, icon: 'fa-jar' },
        { name: 'Almonds', portion: '1 oz', calories: 65, icon: 'fa-seedling' }
      ]
    },
    {
      mealType: 'Lunch',
      time: '12:30 PM',
      calories: 650,
      protein: 40,
      carbs: 65,
      fats: 25,
      image: 'https://kutv.com/resources/media/6b7a7c7c-3c44-489c-9880-4a17508cdc6d-large16x9_Postworkout_meal.jpg?1577802416711',
      foods: [
        { name: 'Grilled Chicken', portion: '6 oz', calories: 280, icon: 'fa-drumstick-bite' },
        { name: 'Brown Rice', portion: '1 cup', calories: 216, icon: 'fa-bowl-rice' },
        { name: 'Mixed Vegetables', portion: '2 cups', calories: 154, icon: 'fa-carrot' }
      ]
    },
    {
      mealType: 'Dinner',
      time: '7:00 PM',
      calories: 550,
      protein: 35,
      carbs: 50,
      fats: 22,
      image: 'https://media.self.com/photos/582e09e73ab10950129051ef/master/w_1600%2Cc_limit/Westend61-GettyImages-681908513.jpg',
      foods: [
        { name: 'Salmon', portion: '6 oz', calories: 354, icon: 'fa-fish' },
        { name: 'Sweet Potato', portion: '1 medium', calories: 103, icon: 'fa-potato' },
        { name: 'Broccoli', portion: '1 cup', calories: 93, icon: 'fa-tree' }
      ]
    }
  ];

  totalCalories = this.dailyNutrition.reduce((sum, meal) => sum + meal.calories, 0);
  totalProtein = this.dailyNutrition.reduce((sum, meal) => sum + meal.protein, 0);
  totalCarbs = this.dailyNutrition.reduce((sum, meal) => sum + meal.carbs, 0);
  totalFats = this.dailyNutrition.reduce((sum, meal) => sum + meal.fats, 0);

  goBack(): void {
    this.location.back();
  }
}

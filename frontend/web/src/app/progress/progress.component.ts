import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { Location } from '@angular/common';
import { Chart, ChartConfiguration } from 'chart.js/auto';

interface WorkoutProgress {
  date: Date;
  weight: number;
  workoutsDone: number;
  caloriesBurned: number;
  duration: number;
  strengthScore?: number;
  cardioScore?: number;
  bodyFat?: number;
  muscleGain?: number;
  waterIntake?: number;
  sleepHours?: number;
}

@Component({
  selector: 'app-progress',
  standalone: true,
  imports: [CommonModule, RouterModule],
  templateUrl: './progress.component.html',
  styleUrls: ['./progress.component.css']
})
export class ProgressComponent implements OnInit {
  progressData: WorkoutProgress[] = [
    { 
      date: new Date(2024, 1, 1), 
      weight: 75, 
      workoutsDone: 3, 
      caloriesBurned: 450, 
      duration: 45,
      strengthScore: 65,
      cardioScore: 70,
      bodyFat: 22,
      muscleGain: 0,
      waterIntake: 2000,
      sleepHours: 7
    },
    { 
      date: new Date(2024, 1, 8), 
      weight: 74.5, 
      workoutsDone: 4, 
      caloriesBurned: 600, 
      duration: 60,
      strengthScore: 68,
      cardioScore: 72,
      bodyFat: 21.5,
      muscleGain: 0.2,
      waterIntake: 2100,
      sleepHours: 7.5
    },
    { date: new Date(2024, 1, 15), weight: 73.8, workoutsDone: 4, caloriesBurned: 550, duration: 55 },
    { date: new Date(2024, 1, 22), weight: 73.2, workoutsDone: 5, caloriesBurned: 750, duration: 75 },
    { date: new Date(2024, 2, 1), weight: 72.5, workoutsDone: 4, caloriesBurned: 600, duration: 60 }
  ];

  totalWeightLoss = this.progressData[0].weight - this.progressData[this.progressData.length-1].weight;
  totalWorkouts = this.progressData.reduce((acc, data) => acc + data.workoutsDone, 0);
  totalCaloriesBurned = this.progressData.reduce((acc, data) => acc + data.caloriesBurned, 0);

  private chartColors = {
    primary: '#4F46E5',    // Indigo
    secondary: '#06B6D4',  // Cyan
    tertiary: '#8B5CF6',   // Purple
    success: '#059669',    // Emerald
    warning: '#F59E0B',    // Amber
    info: '#3B82F6',       // Blue
    accent: '#EC4899',     // Pink
    gradients: {
      primary: ['rgba(79, 70, 229, 0.1)', 'rgba(79, 70, 229, 0.02)'],
      secondary: ['rgba(6, 182, 212, 0.1)', 'rgba(6, 182, 212, 0.02)'],
      tertiary: ['rgba(139, 92, 246, 0.1)', 'rgba(139, 92, 246, 0.02)'],
      success: ['rgba(5, 150, 105, 0.1)', 'rgba(5, 150, 105, 0.02)']
    }
  };

  constructor(private location: Location) {}

  ngOnInit(): void {
    this.initializeCharts();
  }

  goBack(): void {
    this.location.back();
  }

  private initializeCharts(): void {
    this.createWeightChart();
    this.createWorkoutMetricsChart();
    this.createCaloriesChart();
    this.createStrengthChart();
    this.createCardioChart();
    this.createSleepChart();
    this.createHydrationChart();
  }

  private createWeightChart(): void {
    const ctx = document.getElementById('weightChart') as HTMLCanvasElement;
    const config: ChartConfiguration = {
      type: 'line',
      data: {
        labels: this.progressData.map(d => d.date.toLocaleDateString()),
        datasets: [
          {
            label: 'Weight (kg)',
            data: this.progressData.map(d => d.weight),
            borderColor: this.chartColors.primary,
            backgroundColor: this.chartColors.gradients.primary[0],
            tension: 0.3,
            fill: true
          },
          {
            label: 'Body Fat %',
            data: this.progressData.map(d => d.bodyFat ?? null),
            borderColor: this.chartColors.secondary,
            backgroundColor: this.chartColors.gradients.secondary[0],
            tension: 0.3,
            fill: true
          }
        ]
      },
      options: {
        responsive: true,
        plugins: {
          title: { 
            display: true, 
            text: 'Body Composition Progress',
            padding: 20,
            color: '#374151',
            font: { size: 16, weight: 'bold' }
          },
          legend: {
            position: 'bottom',
            labels: { usePointStyle: true, padding: 15 }
          }
        },
        scales: {
          x: {
            grid: { display: false },
            ticks: { color: '#6B7280' }
          },
          y: {
            grid: { color: 'rgba(107, 114, 128, 0.1)' },
            ticks: { color: '#6B7280' }
          }
        }
      }
    };
    new Chart(ctx, config);
  }

  private createWorkoutMetricsChart(): void {
    const ctx = document.getElementById('workoutMetricsChart') as HTMLCanvasElement;
    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: this.progressData.map(d => d.date.toLocaleDateString()),
        datasets: [{
          label: 'Workouts Completed',
          data: this.progressData.map(d => d.workoutsDone),
          backgroundColor: 'rgba(239, 68, 68, 0.8)'
        }]
      },
      options: {
        responsive: true,
        plugins: {
          title: { display: true, text: 'Weekly Workout Frequency' }
        }
      }
    });
  }

  private createCaloriesChart(): void {
    const ctx = document.getElementById('caloriesChart') as HTMLCanvasElement;
    new Chart(ctx, {
      type: 'line',
      data: {
        labels: this.progressData.map(d => d.date.toLocaleDateString()),
        datasets: [{
          label: 'Calories Burned',
          data: this.progressData.map(d => d.caloriesBurned),
          borderColor: 'rgb(239, 68, 68)',
          fill: true,
          backgroundColor: 'rgba(239, 68, 68, 0.1)'
        }]
      },
      options: {
        responsive: true,
        plugins: {
          title: { display: true, text: 'Calories Burned Per Week' }
        }
      }
    });
  }

  private createStrengthChart(): void {
    const ctx = document.getElementById('strengthChart') as HTMLCanvasElement;
    const config: ChartConfiguration = {
      type: 'line',
      data: {
        labels: this.progressData.map(d => d.date.toLocaleDateString()),
        datasets: [{
          label: 'Strength Score',
          data: this.progressData.map(d => d.strengthScore ?? null),
          borderColor: this.chartColors.primary,
          backgroundColor: this.chartColors.gradients.primary[0],
          tension: 0.3,
          fill: true
        }]
      },
      options: {
        responsive: true,
        plugins: {
          title: { 
            display: false
          },
          legend: {
            display: false
          }
        },
        scales: {
          x: {
            grid: { display: false },
            ticks: { color: '#6B7280' }
          },
          y: {
            grid: { color: 'rgba(107, 114, 128, 0.1)' },
            ticks: { color: '#6B7280' }
          }
        }
      }
    };
    new Chart(ctx, config);
  }

  private createCardioChart(): void {
    const ctx = document.getElementById('cardioChart') as HTMLCanvasElement;
    const config: ChartConfiguration = {
      type: 'line',
      data: {
        labels: this.progressData.map(d => d.date.toLocaleDateString()),
        datasets: [{
          label: 'Cardio Score',
          data: this.progressData.map(d => d.cardioScore ?? null),
          borderColor: this.chartColors.info,
          backgroundColor: this.chartColors.gradients.secondary[0],
          tension: 0.3,
          fill: true
        }]
      },
      options: {
        responsive: true,
        plugins: {
          title: { display: false },
          legend: { display: false }
        },
        scales: {
          x: {
            grid: { display: false },
            ticks: { color: '#6B7280' }
          },
          y: {
            grid: { color: 'rgba(107, 114, 128, 0.1)' },
            ticks: { color: '#6B7280' }
          }
        }
      }
    };
    new Chart(ctx, config);
  }

  private createSleepChart(): void {
    const ctx = document.getElementById('sleepChart') as HTMLCanvasElement;
    const config: ChartConfiguration = {
      type: 'bar',
      data: {
        labels: this.progressData.map(d => d.date.toLocaleDateString()),
        datasets: [{
          label: 'Sleep Hours',
          data: this.progressData.map(d => d.sleepHours ?? null),
          backgroundColor: this.chartColors.tertiary,
          borderRadius: 6
        }]
      },
      options: {
        responsive: true,
        plugins: {
          title: { display: false },
          legend: { display: false }
        },
        scales: {
          x: {
            grid: { display: false },
            ticks: { color: '#6B7280' }
          },
          y: {
            grid: { color: 'rgba(107, 114, 128, 0.1)' },
            ticks: { color: '#6B7280' },
            min: 0,
            max: 12
          }
        }
      }
    };
    new Chart(ctx, config);
  }

  private createHydrationChart(): void {
    const ctx = document.getElementById('hydrationChart') as HTMLCanvasElement;
    const config: ChartConfiguration = {
      type: 'bar',
      data: {
        labels: this.progressData.map(d => d.date.toLocaleDateString()),
        datasets: [{
          label: 'Water Intake (ml)',
          data: this.progressData.map(d => d.waterIntake ?? null),
          backgroundColor: this.chartColors.secondary,
          borderRadius: 6
        }]
      },
      options: {
        responsive: true,
        plugins: {
          title: { display: false },
          legend: { display: false }
        },
        scales: {
          x: {
            grid: { display: false },
            ticks: { color: '#6B7280' }
          },
          y: {
            grid: { color: 'rgba(107, 114, 128, 0.1)' },
            ticks: { color: '#6B7280' },
            min: 0
          }
        }
      }
    };
    new Chart(ctx, config);
  }
}

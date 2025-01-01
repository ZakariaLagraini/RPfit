import { ComponentFixture, TestBed } from '@angular/core/testing';

import { WeightLossComponent } from './weight-loss.component';

describe('WeightLossComponent', () => {
  let component: WeightLossComponent;
  let fixture: ComponentFixture<WeightLossComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [WeightLossComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(WeightLossComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

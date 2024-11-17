import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MuscleGainComponent } from './muscle-gain.component';

describe('MuscleGainComponent', () => {
  let component: MuscleGainComponent;
  let fixture: ComponentFixture<MuscleGainComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [MuscleGainComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(MuscleGainComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});

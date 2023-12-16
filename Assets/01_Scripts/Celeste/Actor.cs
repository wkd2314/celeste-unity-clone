﻿using System;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Actors don’t have any concept of their own velocity, acceleration, or gravity.
/// Every class that extends Actor takes care of that
/// </summary>
public class Actor : Entity
{
    private float xRemainder;
    
    
    public float Left { get; set; }
    public float Right { get; set; }

    
    public override void Init()
    {
        base.Init();

        solids = false;
        Level.AllActors.Add(this);
    }

    public void MoveX(float amount, Action onCollide)
    {
        xRemainder += amount;
        int move = Mathf.RoundToInt(xRemainder);
            

        if (move != 0)
        {
            xRemainder -= move;
            int sign = (int)Mathf.Sign(move);

            while (move != 0)
            {
                
                // get the solids besides actor.. how?
                
                if(!CollideAt(solids, Position + new Vector2(sign, 0)))
                {
                    Position.x += sign;
                    move -= sign;
                }
                else
                {
                    if (onCollide != null)
                        onCollide();
                    break;
                }
            }
        }
    }

    public virtual bool IsRiding(Solid[] solid) { return true; }
    public virtual void Squish() { }
    
}


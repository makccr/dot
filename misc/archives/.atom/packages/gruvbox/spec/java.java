package com.somedomain.here;

import java.io.File;
import java.util.List;

import static java.io.File.*;

/**
 * Class <b>JAVA</b> Doc
 *
 * @author Some Important Person
 */
@Awesome("yeah baby!")
public class Foo<T extends List> extends Bar<T> implements SomeInterface {

  private static final int COUNT = 0x243;
  private int myCount = 0;

  @Cool(reason="because")
  public static int staticMethod(String[] values, int n) {
    try {
      System.out.print("This is the value:\n" + values[0]);
    } catch (Exception e) {
      e.printStackTrace();
    }

    if (n > 0) {
      return COUNT; // single line comment
    } else {
      return -COUNT;
    }
  }

  public Foo(int count) {
    myCount = count;
  }

  /* This is a multiple...
      ...line comment. */

  public int getMyCount() throws MyFavoriteException {
    return myCount;
  }

  /**
   * Increment the count
   * @param by the amount to increment by
   */
  public void increment(int by) {
    myCount += by;
  }

  public String describe() {
    switch (myCount) {
      case 0: return "0";
      case 1: return "1";
      default: return "other";
    }
  }

  public MyFooInterface createFooBar() {
    final String test = null;

    return new MyFooInterface() {
      public boolean isValid() {
        return false;
      }
    };
  }

  public static interface MyFooInterface {
    public boolean isValid();
  }
}

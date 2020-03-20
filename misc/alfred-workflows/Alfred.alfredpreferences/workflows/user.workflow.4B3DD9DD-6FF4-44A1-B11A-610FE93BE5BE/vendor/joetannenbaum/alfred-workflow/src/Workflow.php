<?php

namespace Alfred\Workflows;

class Workflow
{
    protected $results = [];

    /**
     * Add a result to the workflow
     *
     * @return \Alfred\Workflows\Result
     */
    public function result()
    {
        $result = new Result;

        $this->results[] = $result;

        return $result;
    }

    /**
     * Sort the current results
     *
     * @param string $direction
     * @param string $property
     *
     * @return \Alfred\Workflows\Workflow
     */
    public function sortResults($direction = 'asc', $property = 'title')
    {
        usort($this->results, function ($a, $b) use ($direction, $property) {
            if ($direction === 'asc') {
                return $a->$property > $b->$property;
            }

            return $a->$property < $b->$property;
        });

        return $this;
    }

    /**
     * Filter current results (destructive)
     *
     * @param string $query
     * @param string $property
     *
     * @return \Alfred\Workflows\Workflow
     */
    public function filterResults($query, $property = 'title')
    {
        if ($query === null || trim($query) === '') {
            return $this;
        }

        $query = (string) $query;

        $this->results = array_filter($this->results, function ($result) use ($query, $property) {
                return strstr($result->$property, $query) !== false;
            });

        return $this;
    }

    /**
     * Output the results as JSON
     *
     * @return string
     */
    public function output()
    {
        $output = [
            'items' => array_map(function ($result) {
                            return $result->toArray();
                        }, array_values($this->results)),
        ];

        return json_encode($output);
    }
}
